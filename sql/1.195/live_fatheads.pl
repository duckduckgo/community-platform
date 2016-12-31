#!/usr/bin/env perl
use warnings;
use FindBin;
use lib "$FindBin::Dir/../../lib";
use strict;
use DDGC;

my $d  = DDGC->new;
my $ias = $d->rs('InstantAnswer');

while (my $ia = $ias->next) {
    next unless $ia->repo and $ia->dev_milestone;
    if($ia->repo eq 'fathead' and $ia->dev_milestone eq 'live'){
        $ia->update({production_state => "online"}); 
    }
}
