#!/usr/bin/env perl
use lib "../lib";
use DDGC::Util::File;

use strict;
use warnings;

my $INST = "../root/static/js";

my $max = max_file_version ($INST, "ia", "js");
my $new = $max + 1;

chdir $INST;

if (`diff ia.js ia$max.js`) {
    print "ia.js unchanged; identical to latest version $max\n";
    exit(1);
}

print "uglifyjs ia.js -o ia$new.js\n";
print `uglifyjs ia.js -o ia$new.js`;
print "git add ia$new.js\n";
print `git add ia$new.js`;

