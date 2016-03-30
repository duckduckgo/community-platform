#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use DDH::UserPage::Gather;
use DDH::UserPage::Generate;
use File::Spec::Functions;
use IPC::Open3;

DDH::UserPage::Generate->new(
    contributors => DDH::UserPage::Gather->new->contributors,
    view_dir     => "$FindBin::Dir/../views",
    build_dir    => "/home/ddgc/ddgc/ddh-userpages"
)->generate;

my($w, $r, $e);
waitpid open3( $w, $r, $e, catfile( $FindBin::Dir, 'markup.pl' ) ), 0;

