#!/usr/bin/env perl
# Get the GH issues for DDG repos
#
#
use FindBin;
use lib $FindBin::Dir . "/../lib";
use JSON;
use DDGC;
use HTTP::Tiny;
use Data::Dumper;
use Try::Tiny;
use Net::GitHub;
use Encode qw(decode_utf8);
my $d = DDGC->new;

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

my $token = $ENV{DDGC_GITHUB_TOKEN} || $ENV{DDG_GITHUB_BASIC_OAUTH_TOKEN};
my $gh = Net::GitHub->new(access_token => $token);

# build a list of the current PRs in our database
my $rs = $d->rs('InstantAnswer::Issues');
my @pull_requests = $rs->search({'is_pr' => 1}, {result_class => 'DBIx::Class::ResultClass::HashRefInflator'})->all;

# turn into issue id hash to make searching easier
my %pr_hash;
map{ $pr_hash{$_->{issue_id}} = $_ } @pull_requests;

# get the GH issues
sub getIssues{
    foreach my $repo (@repos){
        my @issues = $gh->issue->repos_issues('duckduckgo', $repo, {state => 'open'});
        
        while($gh->issue->has_next_page){
            push(@issues, $gh->issue->next_page)
        }

		# add all the data we care about to an array
		for my $issue (@issues){
            # get the IA name from the link in the first comment
			# Update this later for whatever format we decide on
			my $name_from_link = '';
            if($issue->{'body'} =~ /(http(s)?:\/\/(duck\.co|duckduckgo.com))?\/ia\/(view)?\/(\w+)/im){
				$name_from_link = $5;
			}
			# remove special chars from title and body
			$issue->{'body'} =~ s/\'//g;
			$issue->{'title'} =~ s/\'//g;

			# get repo name
			$repo =~ s/zeroclickinfo-//;

            my $is_pr = exists $issue->{pull_request} ? 1 : 0;
            
			# add entry to result array
			my %entry = (
			    name => $name_from_link || '',
				repo => $repo || '',
				issue_id => $issue->{'number'} || '',
                author => $issue->{user}->{login} || '', 
				title => decode_utf8($issue->{'title'}) || '',
				body => decode_utf8($issue->{'body'}) || '',
				tags => $issue->{'labels'} || '',
				date => $issue->{'created_at'} || '',
                is_pr => $is_pr,
                code => '',
			);
			push(@results, \%entry);
		}
	}
    # warn Dumper @results;
}

my $update = sub {
    $d->rs('InstantAnswer::Issues')->delete_all();

    foreach my $result (@results){
        # check if the IA is in our table so we dont die on a foreign key error
        $ia = $d->rs('InstantAnswer')->find( $result->{name});

        if(exists $result->{name} && $ia){
            # check our list of past issues marked as being a pull request
            # if the PR isn't in our new list of issues then get more data
            # on that specific PR using gh api
            if($result->{is_pr} && !$pr_hash{$result->{issue_id}}){
                # Just for testing.  Set a pr to 0
                $result->{is_pr} = 0 if $result->{is_pr};
                my @files;
                $gh->set_default_user_repo('duckduckgo', "zeroclickinfo-$result->{repo}");
                my @pr = $gh->pull_request->files($result->{issue_id});
                map{ push(@files, $_->{filename}) } @pr;
            }

            $d->rs('InstantAnswer::Issues')->create(
            {
                instant_answer_id => $result->{name},
                repo => $result->{repo},
                issue_id => $result->{issue_id},
                title => $result->{title},
                body => $result->{body},
                tags => $result->{tags},
                is_pr => $result->{is_pr},
                date => $result->{date},
                author => $result->{author},
	        });

        }
    }
};

getIssues;

try {
    $d->db->txn_do($update);
} catch {
    print "Update error $_ \n rolling back\n";
    $d->errorlog("Error updating ghIssues: '$_'...");
}
