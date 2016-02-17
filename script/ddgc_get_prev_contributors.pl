#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib $FindBin::Dir . "/../lib";
use JSON;
use DDGC;
use HTTP::Tiny;
use Data::Dumper;
use Try::Tiny;
use Net::GitHub::V3;
use Time::Local;
use Term::ProgressBar;
use Date::Parse;
use Time::Piece;
use Time::Seconds;
use IO::All;

my $d = DDGC->new;

BEGIN {
    $ENV{DDGC_IA_AUTOUPDATES} = 1;
}

# JSON response from GH API
my %json;

# results to go into DB
# |IA name|Repo|Issue#|title|Body|tags|created at|
my @results;

# the repos we care about
my @repos = (
    'zeroclickinfo-spice',
    'zeroclickinfo-goodies',
    'zeroclickinfo-longtail',
    'zeroclickinfo-fathead'
);

my $token = "Add your token here";
my $gh = Net::GitHub->new(access_token => $token);

my @team  = $gh->org->team_members("52625");
    while($gh->org->has_next_page){
        push(@team, $gh->org->next_page)
    }
my $ddgteam;
map{ $ddgteam->{$_->{login} }  = 1 } @team;

my $today = localtime;
# get last days worth of issues
my $since = $today - (500 * ONE_DAY);
my $ias;

MAIN :{
    foreach my $repo (@repos){
        my $line = 1;
        
        warn "Getting all issues since ". $since->datetime;

        my @issues = $gh->issue->repos_issues('duckduckgo', $repo, {
                state => 'all',
                since => $since->datetime
            }
        );

        while($gh->issue->has_next_page){
            push(@issues, $gh->issue->next_page)
        }

        print "Starting $repo\n";
        my $progress = Term::ProgressBar->new(scalar @issues) unless $d->is_live;
		
        # add all the data we care about to an array
		for my $issue (@issues){
            $progress->update($line) unless $d->is_live;
            $line++;

            next if exists $ddgteam->{$issue->{user}->{login}};

            my $state = $issue->{state};
            next if $state eq 'open';

            $state = $gh->pull_request->is_merged('duckduckgo',$repo, $issue->{number})? 'merged' : $state;

            next if $state ne 'merged';

            # get the IA name from the link in the first comment
			# Update this later for whatever format we decide on
			my $name_from_link = '';
            ($name_from_link) = $issue->{'body'} =~ /https?:\/\/duck\.co\/ia\/view\/(\w+)/i;

            next unless $name_from_link;
            
            my $ia = $d->rs('InstantAnswer')->search( {
                    -or => [
                        id => $name_from_link,
                        meta_id => $name_from_link,
                    ]
            } )->hri->one_row;
        
            next unless $ia;

            my $dev_json;
            if(exists $ias->{$ia->{id}}){
                $dev_json = add_developer($ias->{$ia->{id}}, $issue->{user}->{login}, $ia);
            }else{
                $dev_json = add_developer($ia->{developer}, $issue->{user}->{login}, $ia);
            }

            next unless $dev_json;

            $ias->{$ia->{id}} = $dev_json;
        }

    }
    
    foreach my $id (keys $ias){
        sprintf("update instant_answer set developer = '%s' where id = '%s;'\n",
            $ias->{$id}, 
            $id
        ) >> io("devs.sql")->utf8;
    }
}

sub add_developer {
    my ($dev_json, $author, $ia) = @_;
    # don't add duplicates
    return unless $dev_json;
    return if $dev_json =~ /$author/ig;

    my $user = $d->rs('User')->find_by_github_login($author);
    my $data;

    try{
        if($user){
            my $ddgc_name = $user->username;
            # Give edit permissions to the contributor
            $ia->add_to_users($user);
            return if $dev_json =~ /duck.co\/user\/$ddgc_name/g;
        }

        $data = from_json($dev_json);

        my $new_dev = {
            name => $author,
            type => 'github',
            url => "https://github.com/$author"
        };
        push(@{$data}, $new_dev);
        $data = to_json($data);

    }catch{
       # fall back to un-altered dev data
       $data = $dev_json;
    };

   return $data;
}
