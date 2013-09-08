#!/usr/bin/env perl -Ilib
# Quick markup rendering script

use DDGC;
use DDGC::Markup;

my $markup = DDGC::Markup->new(ddgc => DDGC->new);

if (@ARGV && $ARGV[0] ne "-") {
    print $markup->html(@ARGV), "\n";
}

else {
    print "Reading from STDIN...\n";
    print "\n\033[32m", $markup->html(<STDIN>), "\n\033[0m";
}
