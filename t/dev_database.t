#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use File::Temp qw/ tempdir /;

use DDGC;
use DDGCTest::Database;

my $tempdir = tempdir;

$ENV{DDGC_ROOTDIR} = "$tempdir";

DDGCTest::Database->new(DDGC->new({ config => DDGC::Config->new }),1)->deploy;

done_testing;