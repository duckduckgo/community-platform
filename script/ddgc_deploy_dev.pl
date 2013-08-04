#!/usr/bin/env perl

$|=1;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;

use DDGC;
use DDGCTest::Database;
use File::Path qw( make_path remove_tree );
use String::ProgressBar;

use Getopt::Long;

my $config = DDGC::Config->new;

my $kill;
my $start;

GetOptions (
	"kill"  => \$kill,
	"start" => \$start,
);

if (-d $config->rootdir_path) {
  if ($kill) {
    remove_tree($config->rootdir_path);
    if ($ENV{DDGC_DB_DSN} =~ m/^dbi:Pg:/) {
      if ($ENV{DDGC_DB_DSN} =~ m/database=([\w\d]+)/) {
        my $db = $1;
        system("dropdb ".$db);
        system("createdb ".$db);
      } else {
        die "Can't find out your db name from DSN";
      }
    }
  } else {
    die "environment exist, use --kill to kill it!";
  }
}

print "\n";
print "Generating development environment, this may take a while...\n";
print "============================================================\n";
print "\n";

my $ddgc = DDGC->new({ config => $config });

my $pr; 

DDGCTest::Database->new($ddgc,0,sub {
	$pr = String::ProgressBar->new( max => shift );
	$pr->write;
},sub {
	$pr->update(shift);
	$pr->write;
})->deploy;

print "\n\n";
print "done\n";