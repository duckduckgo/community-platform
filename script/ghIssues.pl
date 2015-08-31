#!/usr/bin/env perl
# Get the GH issues for DDG repos
#
#
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

my $token = $ENV{DDGC_GITHUB_TOKEN} || $ENV{DDG_GITHUB_BASIC_OAUTH_TOKEN};
my $gh = Net::GitHub->new(access_token => $token);

# build a list of the PRs in our database
my $rs = $d->rs('InstantAnswer::Issues');
my @pull_requests = $rs->search({'is_pr' => 1}, {result_class => 'DBIx::Class::ResultClass::HashRefInflator'})->all;

# build hash to make searching easier. Concat pr number and repo to avoid collisions
my %pr_hash;
map{ $pr_hash{$_->{issue_id}.$_->{repo}} = $_ } @pull_requests;

#warn Dumper keys %pr_hash;

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

            # get last commit and user info
            my $last_commit;
            $last_commit = get_last_commit($repo, $issue->{number}) if $is_pr;

            # get last comment
            my $last_comment;
            $last_comment = get_last_comment($repo, $issue->{number}) if $is_pr;

            # add entry to result array
			my %entry = (
			    name => $name_from_link || '',
				repo => $repo || '',
				issue_id => $issue->{'number'} || '',
                author => $issue->{user}->{login} || '', 
				title => $issue->{'title'} || '',
				body => $issue->{'body'} || '',
				tags => $issue->{'labels'} || '',
				date => $issue->{'created_at'} || '',
                is_pr => $is_pr,
                last_update => $issue->{updated_at},
                last_commit => $last_commit,
                last_comment => $last_comment,
			);

			push(@results, \%entry);
            delete $pr_hash{$issue->{'number'}.$repo};
            
            my $create_page = sub {
                my $data = \%entry;
                return unless $data->{name};

                # check to see if we have this IA already
                # First lookup by ID.  This can fail if an admin updates the ID on the IA page later
                my $ia = $d->rs('InstantAnswer')->search( {
                    -or => [
                        id => $data->{name},
                        meta_id => $data->{name},
                    ]
                } )->hri->one_row;
                my $new_ia = 1 if !$ia;

                my @time = localtime(time);
                my $date = "$time[4]/$time[3]/".($time[5]+1900);

                $data->{body} =~ s/\n|\r//g;

                # try to get a description from the PR text
                my ($description) = $data->{body} =~ /What does your Instant Answer do\?\*\*(.*?)(?:\*|$)/i;
                
                # api documentation
                my ($api_link) = $data->{body} =~ /What is the data source.*?\*\*.*?(https?:\/\/.*?)?(?:\>|\)|\*|$)/i;

                # api documentation
                my ($forum_link) = $data->{body} =~ /Is this Instant Answer connected.*?\*\*.*?(https?:\/\/.*?)?(?:\>|\)|\*|$)/i;
                if ($forum_link) {
                    $forum_link =~ /[0-9]+$/i;
                }
                
                # get the file info for the pr
                $gh->set_default_user_repo('duckduckgo', "zeroclickinfo-$data->{repo}");
                my $pr = $gh->pull_request->pull($data->{issue_id});
                my @files_data = $gh->pull_request->files($data->{issue_id});

                my $pm;
                # look for the perl module
                for my $file (@files_data){
                    my $tmp_repo = ucfirst $data->{repo};
                    $tmp_repo =~ s/s$//g;

                    if(my ($name) = $file->{filename} =~ /lib\/DDG\/$tmp_repo\/(.+)\.pm/i ){
                        my @parts = split('/', $name);
                        $name = join('::', @parts);
                        $pm = "DDG::".$tmp_repo."::$name";
                        last;
                    }
                }

                my $is_new_ia;
                for my $tag (@{$data->{tags}}){
                    $is_new_ia = 1 if $tag->{name} eq 'New Instant Answer';
                    $pm = "DDG::Goodie::CheatSheets" if $tag->{name} eq 'CheatSheet';
                }
                return if !$is_new_ia;

                my $developer = [{
                        name => $data->{author},
                        type => 'github',
                        url => "https://github.com/$data->{author}"
                    }];
                $developer = to_json $developer;

                my $name = $data->{name};
                $name =~ s/_/ /g;

                my %new_data = (
                    id => $ia->{id} || $data->{name},
                    meta_id => $ia->{meta_id} || $data->{name},
                    name => $ia->{name} || ucfirst $name,
                    dev_milestone => $ia->{dev_milestone} || 'planning',
                    description => $ia->{description} || $description,
                    created_date => $ia->{created_date} || $date, 
                    repo => $ia->{repo} || $data->{repo},
                    perl_module => $ia->{perl_module} || $pm,
                    forum_link => $ia->{forum_link} || $forum_link,
                    src_api_documentation => $ia->{src_api_documentation} || $api_link,
                    developer => $ia->{developer} || $developer,
                    last_update => $issue->{updated_at},
                    last_commit => $data->{last_commit},
                    last_comment => $data->{last_comment},
                );

                $d->rs('InstantAnswer')->update_or_create({%new_data});
            };

            # check for an existing IA page.  Create one if none are found
            try {
                $d->db->txn_do($create_page) if $is_pr;
            } catch {
                print "Update error $_ \n rolling back\n";
                $d->errorlog("Error updating ghIssues: '$_'...");
            }

		}
	}
    # warn Dumper @results;
    # warn Dumper %pr_hash;
}

sub get_last_commit {
    my ($repo, $issue) = @_;
    my $pulls = $gh->pull_request;
    my @commits = $pulls->commits('duckduckgo', "zeroclickinfo-$repo", $issue);
    my $commit = pop @commits;

    return unless $commit;

    my $last_commit = { 
        diff => $commit->{html_url}, 
        user => $commit->{commit}->{committer}->{name},
        date => $commit->{commit}->{committer}->{date},
        message => $commit->{commit}->{message},
    };

    return to_json $last_commit;
}

sub get_last_comment {
    my ($repo, $issue) = @_;
    my $issues = $gh->issue;
    my @comments = $issues->comments('duckduckgo', "zeroclickinfo-$repo", $issue);
    my $comment = pop @comments;

    return unless $comment;

    my $last_comment = { 
        user => $comment->{user}->{login},
        date => $comment->{created_at},
        text => $comment->{body},
        id => $comment->{id}
    };

    return to_json $last_comment;
}

# check the status of PRs in $pr_hash.  If they were merged
# then update the file paths in the db
my $merge_files = sub {
    PR: while ( my ($pr, $data) = each %pr_hash){
        $gh->set_default_user_repo('duckduckgo', "zeroclickinfo-$data->{repo}");
        my $pr = $gh->pull_request->pull($data->{issue_id});

        # closed PRs have undef merged_at.  Merged ones have the date
        next PR unless $pr->{merged_at};
        
        my @files_changed = $gh->pull_request->files($data->{issue_id});

        my @files;
        map{ push(@files, $_->{filename}) } @files_changed;

        #update code in db
        my $result = $d->rs('InstantAnswer')->find({id => $data->{instant_answer_id}});
        $result->update({code => JSON->new->ascii(1)->encode(\@files)}) if $result;
    }
};

my $update = sub {
    $d->rs('InstantAnswer::Issues')->delete_all();

    foreach my $result (@results){
        # check if the IA is in our table so we dont die on a foreign key error

        my $ia = $d->rs('InstantAnswer')->search( {
            -or => [
                id => $result->{name},
                meta_id => $result->{name},
            ]
        } )->one_row;
 
        if(exists $result->{name} && $ia){
            $d->rs('InstantAnswer::Issues')->create({
                instant_answer_id => $ia->id,
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
    $d->db->txn_do($merge_files);
    $d->db->txn_do($update);
} catch {
    print "Update error $_ \n rolling back\n";
    $d->errorlog("Error updating ghIssues: '$_'...");
}

