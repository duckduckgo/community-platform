#!/usr/bin/env perl

use strict;
use warnings;
use DDP;

while (<>) {
  chomp($_);
  $_ =~ m/^dukgo\.com \[([^\]]+)\] "([^"]+)" (\d+) ([\d\.]+) (\d+) "([^"]+)"/;
  print '127.0.0.1 - - ['.$1.'] "'.$2.'" '.$3.' '.$5.' "'.$6.'"'."\n";
}