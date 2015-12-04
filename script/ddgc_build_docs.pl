#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";
use DDGC::Util::Script::Docs;

DDGC::Util::Script::Docs->new->execute;
