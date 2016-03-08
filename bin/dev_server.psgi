#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Plack::Builder;
use Plack::App::Directory;

builder {
    mount '/' => Plack::App::Directory->new( root => $FindBin::Dir . "/../build/" )->to_app;
};

