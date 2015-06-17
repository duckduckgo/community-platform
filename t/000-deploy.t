use strict;
use warnings;

BEGIN {
    $ENV{DDGC_DB_DSN} = 'dbi:SQLite:dbname=ddgc_test.db';
}

use t::lib::DDGC::TestUtils;
use Test::More tests => 1;

ok(t::lib::DDGC::TestUtils::deploy({ drop => 1 }), 'deploying new db');

