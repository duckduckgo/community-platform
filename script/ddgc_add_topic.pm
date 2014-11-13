#!/usr/bin/env perl

use FindBin;
use lib $FindBin::Dir . "/../lib";
use strict;
use DDGC;

my $topic_name = $ARGV[0];

die "please specify a topic" unless $topic_name;

my $d  = DDGC->new;

my $topic = $d->rs('Topic')->find({ name => $topic_name });

die "topic already exists" if $topic;

my $topic = $d->rs('Topic')->new({ name => $topic_name });
$topic->insert;

print "topic ".$topic_name." successfully added\n";
