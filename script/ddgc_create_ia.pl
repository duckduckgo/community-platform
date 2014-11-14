#!/usr/bin/env perl

use utf8;
use FindBin;
use lib $FindBin::Dir . "/../lib";
use strict;
use DDGC;

my $ia_name = shift @ARGV;
my $ia_id = shift @ARGV;
my $ia_status = shift @ARGV;

die "please insert a name for the Instant Answer" unless $ia_name;

my $d  = DDGC->new;

my $ia = $d->rs('InstantAnswer')->find({lc id => $ia_id});

die "id ".$ia_id." is already in use" if $ia;

my $new_ia = $d->rs('InstantAnswer')->create({
        lc id => $ia_id,
        name => $ia_name,
        status => $ia_status,
        dev_milestone => $ia_status,
        description => '',
        repo => '',
        perl_module => '',
        topic => [],
        attribution => [],
        example_query => '',
        src_name => '' 
    });

print "new Instant Answer ".$ia_name." successfully created\n";
