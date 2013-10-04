#!/usr/bin/env perl

$|=1;

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use DDGC;

my $ddgc = DDGC->new;

$ddgc->rs('Thread')->search_rs({ data => { -like => '%___duckco_import___%' } })->delete;
$ddgc->rs('Comment')->search_rs({ data => { -like => '%___duckco_import___%' } })->delete;
$ddgc->rs('Comment')->search_rs({ data => { -like => '%___uservoice_import___%' } })->delete;
$ddgc->rs('Idea')->search_rs({ data => { -like => '%___uservoice_import___%' } })->delete;

