#!/usr/bin/env perl
use lib "../lib";
use DDGC::Util::File;

use strict;
use warnings;


# TODO correct release directories
my $INST = "../root/static/js";

die ("no $INST/ia.js") unless (-f "$INST/ia.js");

my $max = max_file_version ($INST, "ia", "js");
my $new = $max + 1;


if (`diff ia.js ia$max.js`) {
    print "ia.js unchanged; identical to latest version $max\n";
    exit(1);
}

print "uglifyjs $INST/ia.js -o $INST/ia$new.js\n";
print `uglifyjs $INST/ia.js -o $INST/ia$new.js`;
print "git add $INST/ia$new.js\n";
print `git add $INST/ia$new.js`;

# should rm ia.js now
unlink("$INST/ia.js");

