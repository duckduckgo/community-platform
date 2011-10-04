#!/usr/bin/perl

use utf8;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;

use DDGC;
use DDGCTest::Database;
use File::Path qw( make_path remove_tree );

use Getopt::Long;

my $kill;

GetOptions (
	"kill"  => \$kill,
);

if (-d DDGC::Config::rootdir_path) {
	$kill ? remove_tree(DDGC::Config::rootdir_path) : die "environment exist, use --kill to kill it!"
}

DDGCTest::Database->new(DDGC->new)->deploy;
