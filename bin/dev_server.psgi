#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Plack::Builder;
use Plack::App::Directory;
use Plack::App::File;

builder {
    mount '/' => Plack::App::Directory->new( root => $FindBin::Dir . "/../build/" )->to_app;
    mount "/static" => Plack::App::File->new(root => $FindBin::Dir . '/../root/static')->to_app;
};

