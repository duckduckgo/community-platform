#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";
use DDGC::Util::Script::ActivityMailer;

die 'This emails people... See crontab.' if (!$ARGV[0] || $ARGV[0] ne '--yes-really-send-email');

DDGC::Util::Script::ActivityMailer->new->execute;

