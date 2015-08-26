#!/usr/bin/env perl
# check all claimed ideas and make sure they have an IA page.
# if not then make one
use FindBin;
use lib $FindBin::Dir . "/../lib";
use JSON;
use DDGC;
use HTTP::Tiny;
use Data::Dumper;
use Try::Tiny;
use Net::GitHub;
use Time::Local;
my $d = DDGC->new;

BEGIN {
    $ENV{DDGC_IA_AUTOUPDATES} = 1;
}

MAIN: {
    my $claimed_without_page = $d->rs('Idea')
        ->search({
            claimed_by          => !undef,
            instant_answer_id   => undef,
        });

    warn Dumper $claimed_without_page;
}
