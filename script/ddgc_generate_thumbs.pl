#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use DDGC;

my $d = DDGC->new;
my $images = $d->rs('Media');

while (my $image = $images->next) {
    $image->generate_thumbnail;
}
