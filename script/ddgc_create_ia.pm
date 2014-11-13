#!/usr/bin/env perl


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

my $new_ia = $d->rs('InstantAnswer')->new({
        lc id => $ia_id,
        name => $ia_name,
        status => $ia_status 
    });
$new_ia->insert;

print "new Instant Answer ".$ia_name." successfully created\n";
