#!/usr/bin/env perl

$|=1;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;

use DDGC::Config;

my $cycle = shift @ARGV;

die "Need cycle!" unless $cycle;
die "Unknown cycle!" unless $cycle >= 2 && $cycle <= 4;

$ENV{DDGC_EXECUTE_CRONJOBS} = 'YES';

my $base = DDGC::Config->new->web_base;

use Catalyst::Test qw( DDGC::Web );

my $response = request($base.'/cronjob/notify_cycle/'.$cycle);

print $response->content;

exit ( $response->is_success ? 0 : 1 );