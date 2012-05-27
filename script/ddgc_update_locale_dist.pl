#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use DDGC;
use DDGC::LocaleDist;
use Getopt::Long;
use File::Copy;

my $domain;

GetOptions(
	"domain=s" => \$domain,
);

die 'you must give a --domain' unless $domain;

my $ddgc = DDGC->new;
my $td = $ddgc->resultset('Token::Domain')->search({ key => $domain },{ prefetch => 'tokens' })->next;

my $local_dist = DDGC::LocaleDist->new( token_domain => $td );
my $user = $ddgc->find_user($ddgc->config->duckpan_locale_uploader);

$ddgc->duckpan->add_user_distribution($user,$local_dist->distribution_file);

print "\nDone...\n\n";
