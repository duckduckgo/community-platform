#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
    $ENV{DDGC_DB_DSN} = 'dbi:SQLite:dbname=ddgc_test.db';
}

if ( -f 'ddgc_test.db' ) {
    printf "Test db exists, exiting...\n";
    exit 1;
}

use FindBin;
use lib $FindBin::Dir . "/../lib";

use DDGC;
use DDGC::DB;
DDGC::DB->connect( DDGC->new )->deploy;

