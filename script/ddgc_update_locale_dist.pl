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
use DDP;
use DateTime;

my $domain;
my $target;
my $force = 0;
my $delta = '12h';

GetOptions(
	"domain=s" => \$domain,
	"target=s" => \$target,
	"force"    => \$force,
	"delta=s"  => \$delta,
);

die 'you must give a --domain' unless $domain;

$target = dir($target)->absolute if $target;

my $ddgc = DDGC->new;

goto PUBLISH if $force;

my $delta_elements = { reverse $delta =~ /([0-9]+)([smhd])/g };
my $then_dt = DateTime->now->subtract(
	DateTime::Duration->new(
		seconds => $delta_elements->{s} // 0,
		minutes => $delta_elements->{m} // 0,
		hours   => $delta_elements->{h} // 0,
		days    => $delta_elements->{d} // 0,
	)
);

my @updated_since_then = map {
	$ddgc->resultset( $_ )->search({
		updated => {
			'>=' => $ddgc->db->storage->datetime_parser->format_datetime( $then_dt )
		}
	})->all
} qw/ Token::Language::Translation Token::Language::Translation::Vote /;

die "Skipping locale package publish - no new data in last $delta" unless scalar @updated_since_then;

PUBLISH:

my $td = $ddgc->resultset('Token::Domain')->search({ key => $domain },{ prefetch => 'tokens' })->next;

my $local_dist = DDGC::LocaleDist->new( token_domain => $td );
my $user = $ddgc->find_user($ddgc->config->duckpan_locale_uploader);

if ($target) {
	print "\nCopying ".$local_dist->distribution_file->basename." to ".$target."\n";
	copy($local_dist->distribution_file, file($target,$local_dist->distribution_file->basename));
} else {
	print "\nAdding to DuckPAN...\n";
	p($ddgc->duckpan->add_user_distribution($user, $local_dist->distribution_file));
}

print "\nDone...\n\n";
