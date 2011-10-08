#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib $FindBin::Dir . "/../lib";

use DDGC::App::PoGenerator;


DDGC::App::PoGenerator->new_with_options();
