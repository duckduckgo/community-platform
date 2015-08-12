#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";
use DDGC::Util::Script::ActivityMailer;

DDGC::Util::Script::ActivityMailer->new->execute;

