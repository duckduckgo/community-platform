#!/usr/bin/perl

$|=1;

use utf8::all;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;

use DDGC;
use DDGCTest::Database;
use DDGCTest::DatabaseStart;
use File::Path qw( make_path remove_tree );

use Getopt::Long;

my $kill;
my $start;

GetOptions (
	"kill"  => \$kill,
	"start" => \$start,
);

if (-d DDGC::Config::rootdir_path) {
	$kill ? remove_tree(DDGC::Config::rootdir_path) : die "environment exist, use --kill to kill it!"
}

print "Generating database, this may take a while... ";

if ($start) {
	DDGCTest::DatabaseStart->new(DDGC->new)->deploy;
} else {
	DDGCTest::Database->new(DDGC->new)->deploy;
}

print "done\n";