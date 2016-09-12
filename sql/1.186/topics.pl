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

my $help_topic = $d->rs('Topic')->create({
    name => "help"
});


my $lib_topic = $d->rs('Topic')->create({
    name => "libraries"
});
