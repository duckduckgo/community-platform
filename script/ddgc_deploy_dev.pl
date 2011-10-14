#!/usr/bin/perl

use utf8;

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

if ($start) {
	DDGCTest::DatabaseStart->new(DDGC->new)->deploy;
} else {
	DDGCTest::Database->new(DDGC->new)->deploy;
}
