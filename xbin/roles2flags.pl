#!/usr/bin/env perl

$|=1;

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use DDGC;

my $ddgc = DDGC->new;

for ($ddgc->db->resultset('User')->search({})->all) {
  $_->flags([split(/,/,$_->roles)]);
  $_->update;
  print ".";
}

print "\n";