#!/usr/bin/env perl
use FindBin;
use lib $FindBin::Dir . "/../lib";
use strict;
use warnings;
use Data::Dumper;
use Try::Tiny;
use File::Copy qw( move );

use DDGC;
use JSON;
use IO::All;
use Term::ANSIColor;

my $d = DDGC->new;

my $update = sub { 
    $d->rs('Traffic')->delete;

    # get data out of sql file

    # make statement


    $ia->{code} = JSON->new->ascii(1)->encode($ia->{code});
    my $topic = $d->rs('Topic')->update_or_create({name => $topic_name});
;

try{
    $d->db->txn_do( $update );
} catch {
    print "Update error, rolling back\n";
    $d->errorlog("Error updating iameta, Rolling back update: $_");
};

