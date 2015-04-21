#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Dir/../../lib";
use strict;
use DDGC;

my $d  = DDGC->new;
my $ias = $d->rs('InstantAnswer');

while (my $ia = $ias->next) {
    $ia->update({meta_id => $ia->id});
}
