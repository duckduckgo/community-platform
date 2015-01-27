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

# get the GH issues
sub getIssues{
	foreach my $repo (@repos){
        my $url = "https://api.github.com/repos/duckduckgo/$repo/issues?status=current";
		my $response = HTTP::Tiny->new->get($url);
        
        die $d->errorlog("Error at $url $response->{status} $response->{reason}")
            unless $response->{success};

        $json->{$repo} = decode_json($response->{content});

		next unless ref $json->{$repo} eq 'ARRAY';

		# add all the data we care about to an array
		for my $issue ( @{$json->{$repo}} ){

            # get the IA name from the link in the first comment
			# Update this later for whatever format we decide on
			my $link = '';
            if($issue->{'body'} =~ /(http(s)?:\/\/(duck\.co|duckduckgo.com))?\/ia\/(view)?\/(.*)/im){
				$link = $5;
			}
			# remove special chars from title and body
			$issue->{'body'} =~ s/\'//g;
			$issue->{'title'} =~ s/\'//g;

			# get repo name
			$repo =~ s/zeroclickinfo-//;

			# add entry to result array
			my @entry = (
				$link || '',
				$repo || '',
				$issue->{'number'} || '',
				$issue->{'title'} || '',
				$issue->{'body'} || '',
				encode_json($issue->{'labels'}) || '',
				$issue->{'created_at'} || ''
			);
			push(@results, \@entry);
		}
	}
}

sub updateDB{

    $d->rs('InstantAnswer::Issues')->delete_all();

    foreach (@results){
        if(@$_[0] and @$_[2]){

		$d->rs('InstantAnswer::Issues')->create(
            {
                instant_answer_id => @$_[0],
                repo => @$_[1],
                issue_id => @$_[2],
                title => @$_[3],
                body => @$_[4],
                tags => @$_[5],
	        });
        }
    }
}

getIssues;

updateDB;

