#!/usr/bin/env perl
use warnings;
use FindBin;
use lib "$FindBin::Dir/../../lib";
use strict;
use DDGC;

my $d  = DDGC->new;
my $ias = $d->rs('InstantAnswer');

while (my $ia = $ias->next) {
    my $forum_link = $ia->forum_link;
    next unless $forum_link;

    warn $forum_link;

    my $is_valid_link = 1;

    if ($forum_link =~ /#/){
        $is_valid_link = 0;
    }
    
    my ($new_link) = $forum_link =~ /([0-9]+)/i;
    
    if($is_valid_link && !$new_link){
        if($forum_link !~ /ideas\/idea\//){
            $is_valid_link = 0;
        }
    }


    if($new_link && $is_valid_link){
        $ia->update({forum_link => $new_link});
    }
    else {
        $ia->update({forum_link => undef});
    }
}
