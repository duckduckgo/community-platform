#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use Plack::Builder;
use Plack::App::Directory::WithIndex;
use Plack::App::File;

use DDH::UserPage::Generate;

DDH::UserPage::Generate->new(
    view_dir     => "$FindBin::Dir/../views",
    build_dir    => "/home/ddgc/ddgc/ddh-userpages",
)->generate;

builder {
    mount '/' => Plack::App::Directory::WithIndex->new( root => "/home/ddgc/ddgc/ddh-userpages" )->to_app;
    mount "/ddh-static" => Plack::App::File->new(root => $FindBin::Dir . '/../root/static')->to_app;
};

