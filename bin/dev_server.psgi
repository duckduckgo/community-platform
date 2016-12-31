#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use Plack::Builder;
use Plack::App::Directory::WithIndex;
use Plack::App::File;

use DDH::UserPage::Generate;

my $root = $ENV{USERPAGE_OUT} || "/home/ddgc/ddgc/ddh-userpages";

if ( !$ENV{SKIP_GENERATE} ) {
    DDH::UserPage::Generate->new(
        view_dir     => "$FindBin::Dir/../views",
        build_dir    => $root,
    )->generate;
}

builder {
    mount '/u' => Plack::App::Directory::WithIndex->new( root => $root )->to_app;
    mount "/ddh-static" => Plack::App::File->new(root => $FindBin::Dir . '/../root/static')->to_app;
};

