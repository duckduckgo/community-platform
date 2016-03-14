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
    build_dir    => "$FindBin::Dir/../build",
)->generate;

builder {
    mount '/' => Plack::App::Directory::WithIndex->new( root => $FindBin::Dir . "/../build" )->to_app;
    mount "/static" => Plack::App::File->new(root => $FindBin::Dir . '/../root/static')->to_app;
};

