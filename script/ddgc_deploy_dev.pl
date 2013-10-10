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
use POSIX;
use DBI;

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
    # TODO: replace parsing of dsn using regex with some CPAN module, DRY
    if ($config->db_dsn =~ m/^dbi:Pg:/) {
      if ($config->db_dsn =~ m/(?:database|dbname)=([\w\d]+)/) {
        my $db = $1;
        my $userarg = length($config->db_user) ? "-U ".$config->db_user : "";
	print "Truncating database...\n";
        system("dropdb $userarg ".$db);
	if ( !WIFEXITED(${^CHILD_ERROR_NATIVE}) ) {
	    my $dsn = $config->db_dsn;
	    $dsn =~ s/(database|dbname)=[\w\d]+/$1=postgres/;
	    my $dbh = DBI->connect(
		$dsn, $config->db_user, $config->db_password
	    );
	    $dbh->do("DROP DATABASE $db") or die $dbh->errstr;
	    $dbh->do("CREATE DATABASE $db") or die $dbh->errstr;
        }
        else {
	    system("createdb $userarg ".$db);
	}
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
print "Deploying fresh environment into ".$config->rootdir_path."\n";
print "Deploying database structure to dsn '".$config->db_dsn."'\n";
print "\n";

my $ddgc = DDGC->new({ config => $config });

my $pr; 

my $ddgc_test = DDGCTest::Database->new($ddgc,0,sub {
  print "\n";
  print "Filling database with test data\n";
  print "\n";
	$pr = String::ProgressBar->new(
    max => shift,
    length => 60,
    bar => '#',
    show_rotation => 1,
    print_return => 0,
  );
	$pr->write;
},sub {
	$pr->update(shift);
	$pr->write;
});
$ddgc_test->deploy;

print "\n\n";
print "Updating notifications... (will take a while) ";
$ddgc_test->update_notifications;
print "done\n";
print "\n";
print "everything done... You can start the development webserver with:\n\n";
print "  script/ddgc_web_server.pl -r -d\n\n";
print "or generate new flag sprites with:\n\n";
print "  script/ddgc_generate_flag_sprites.pl\n\n";
