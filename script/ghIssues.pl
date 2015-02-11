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
				title => decode_utf8($issue->{'title'}) || '',
				body => decode_utf8($issue->{'body'}) || '',
				tags => encode_json($issue->{'labels'}) || '',
				created => $issue->{'created_at'} || '',
                is_pr => $is_pr,
			);
			push(@results, \%entry);
		}
	}
    #  warn Dumper @results;
}

my $update = sub {
    $d->rs('InstantAnswer::Issues')->delete_all();

    foreach my $result (@results){
        # check if the IA is in our table so we dont die on a foreign key error
        $ia = $d->rs('InstantAnswer')->find( $result->{name});

        if(exists $result->{name} && $ia){
            $d->rs('InstantAnswer::Issues')->create(
            {
                instant_answer_id => $result->{name},
                repo => $result->{repo},
                issue_id => $result->{issue_id},
                title => $result->{title},
                body => $result->{body},
                tags => $result->{tags},
                is_pr => $result->{is_pr},
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
