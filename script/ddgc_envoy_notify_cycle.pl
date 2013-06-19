#!/usr/bin/env perl

$|=1;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;

use DDGC;

my $cycle = shift @ARGV;

die "Need cycle!" unless $cycle;

die "Unknown cycle!" unless $cycle >= 2 && $cycle <= 4 ;

DDGC->new->envoy->notify_cycle($cycle);
