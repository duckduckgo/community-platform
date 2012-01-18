#!/usr/bin/perl

$|=1;

use utf8::all;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;

use DDGC;
use DDGCTest::Database;
use File::Path qw( make_path remove_tree );

use Getopt::Long;

my $config = DDGC::Config->new;

my $kill;
my $start;

GetOptions (
	"kill"  => \$kill,
	"start" => \$start,
);

if (-d $config->rootdir_path) {
	$kill ? remove_tree($config->rootdir_path) : die "environment exist, use --kill to kill it!"
}

print "Generating database, this may take a while... ";

my $ddgc = DDGC->new({ config => $config });

DDGCTest::Database->new($ddgc)->deploy;

print "done\n";