#!/usr/bin/env perl

$|=1;

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use DDGC;
use DDGC::LocaleDist;
use Getopt::Long;
use File::Copy;
use Path::Class;

my $domain;
my $target;

GetOptions(
	"domain=s" => \$domain,
	"target=s" => \$target,
);

die 'you must give a --domain' unless $domain;

$target = dir($target)->absolute if $target;

my $ddgc = DDGC->new;
my $td = $ddgc->resultset('Token::Domain')->search({ key => $domain },{ prefetch => 'tokens' })->next;

my $local_dist = DDGC::LocaleDist->new( token_domain => $td );
my $user = $ddgc->find_user($ddgc->config->duckpan_locale_uploader);

if ($target) {
	print "\nCopying ".$local_dist->distribution_file->basename." to ".$target."\n";
	copy($local_dist->distribution_file, file($target,$local_dist->distribution_file->basename));
} else {
	print "\nAdding to DuckPAN...\n";
	$ddgc->duckpan->add_user_distribution($user, $local_dist->distribution_file);
}

print "\nDone...\n\n";
