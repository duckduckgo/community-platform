#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use Plack::Builder;
use Plack::App::Directory::WithIndex;
use Plack::App::File;

builder {
    mount '/' => Plack::App::Directory::WithIndex->new( root => $FindBin::Dir . "/../build" )->to_app;
    mount "/static" => Plack::App::File->new(root => $FindBin::Dir . '/../root/static')->to_app;
};

