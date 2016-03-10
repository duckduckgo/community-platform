#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use DDH::UserPage::Gather;
use DDH::UserPage::Generate;

DDH::UserPage::Generate->new(
    contributors => DDH::UserPage::Gather->new->contributors,
    view_dir     => "$FindBin::Dir/../views",
    build_dir    => "$FindBin::Dir/../build",
    json_build_dir    => "$FindBin::Dir/../json_build",
)->generate;

