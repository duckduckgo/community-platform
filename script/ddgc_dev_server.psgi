#!/usr/bin/env perl

# Development server builder.
# See ddgc_dev_server.sh

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use Plack::Builder;
use DDGC::Web;
my $ddgc_home = '/home/' . (getpwuid($<))[0] . '/ddgc';

builder {

    enable 'Debug', panels => [
        qw/ Environment Response Parameters Timer Memory Session DBITrace CatalystLog /
    ];

    mount '/' => DDGC::Web->new->psgi_app;

    mount "/static" => Plack::App::File->new( root => $FindBin::Dir . '/../root/static' )->to_app;
    mount "/media" => Plack::App::File->new( root => "$ddgc_home/media" )->to_app;
    mount "/thumbnail" => Plack::App::File->new( root => "$ddgc_home/media/thumbnail" )->to_app;
    mount "/generated_css" => Plack::App::File->new( root => "$ddgc_home/cache/generated_css" )->to_app;
    mount "/generated_images" => Plack::App::File->new( root => "$ddgc_home/cache/generated_images" )->to_app;
};

