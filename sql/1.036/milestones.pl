#!/usr/bin/env perl
#
use FindBin;
use lib "$FindBin::Dir/../../lib";
use strict;
use DDGC;

my $d  = DDGC->new;
my $ias = $d->rs('InstantAnswer')->search({dev_milestone => { '=' => ['in_development', 'qa', 'ready']}});

while (my $ia = $ias->next) {
    my $milestone = $ia->dev_milestone;
    if ($milestone eq 'in_development') {
        $ia->update({dev_milestone => 'development'});
    } elsif ($milestone eq 'qa') {
        $ia->update({dev_milestone => 'testing'});
    } elsif ($milestone eq 'ready') {
        $ia->update({dev_milestone => 'complete'});
    }
}
