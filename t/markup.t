#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;

my %tests = (
    '[quote]Hello, World.[/quote]' => ["<div class='bbcode_quote_header'>Quote:<div class='bbcode_quote_body'>Hello, World.</div></div>", "Hello, World."],
    '[quote=somebody]Hello, World.[/quote]' => ["<div class='bbcode_quote_header'>Quote from <a href='/somebody'>somebody</a>:<div class='bbcode_quote_body'>Hello, World.</div></div>","Hello, World."],
    '@somebody' => ["<a href='/somebody'>\@somebody</a>", '@somebody'],
);

plan tests => int(keys(%tests)) * 2;

use DDGC;
my $ddgc = DDGC->new;

my $counter = 0;
for my $bbcode (keys %tests) {
    is $ddgc->markup->html($bbcode), $tests{$bbcode}->[0], "bbcode parse #$counter";
    is $ddgc->markup->plain($bbcode), $tests{$bbcode}->[1], "bbcode strip #$counter";

    $counter++;
}

done_testing;
