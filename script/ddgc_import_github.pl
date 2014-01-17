#!/usr/bin/env perl

use utf8;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;
use DDGC;

my $ddgc = DDGC->new;
$ddgc->github->update_database;

exit 0;