#!/usr/bin/env perl

use FindBin;
use lib "$FindBin::Dir/../../lib";
use strict;
use DDGC;

my $d  = DDGC->new;
my $ias = $d->rs('InstantAnswer');

while (my $ia = $ias->next) {
    my $forum_link = $ia->forum_link;

    if ($forum_link) {
        $forum_link =~ /[0-9]+$/i;
        $ia->update({forum_link => $forum_link});
    }
}

