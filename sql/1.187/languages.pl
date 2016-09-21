#!/usr/bin/env perl
# recover a dev database with whatever is live on duck.co/ia/view/$repo/json enpoints
# ./ddgc_rebuild_dev_db.pl --repo <repo to delete> --ia <ia to delete>
# default (no options) deletes everything
#
use FindBin;
use lib $FindBin::Dir . "/../../lib";
use strict;
use warnings;
use DDGC;
use Try::Tiny;

my $d = DDGC->new;
my @languages = [
    "java",
    "PHP",
    "HTML",
    "C",
    "C#",
    "C++",
    "ruby",
    "Objective-C",
    "R",
    "scala",
    "haskell"
    ];

for my $i (0 .. $#languages) {
    my $temp_topic = $d->rs('Topic')->update_or_create({
        name => $languages[0][$i]
    });
}

