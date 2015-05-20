#!/usr/bin/env perl

# Development server builder.
# See ddgc_dev_server.sh

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use Plack::Builder;
use CHI;
use DDGC::Web;
use DDGC::Web::App::Blog;
use DDGC::Web::Service::Blog;
use DDGC::Static;
my $ddgc_home = '/home/' . (getpwuid($<))[0] . '/ddgc';

builder {
    enable 'StackTrace', force => 1;
    enable 'Session::Simple',
        store => CHI->new(
            driver => 'File',
            root_dir => '/tmp/ddgc_session',
        ),
        keep_empty => 0,
        secure => 0,
        httponly => 1,
        expires => '+21600s',
        cookie_name => 'ddgc_session';
    enable 'Debug', panels => [
        qw/ Environment Response Parameters Timer Memory Session DBITrace CatalystLog /
    ];
    mount '/blog' => DDGC::Web::App::Blog->to_app;
    mount '/blog.json' => DDGC::Web::Service::Blog->to_app;
    mount '/' => DDGC::Web->new->psgi_app;
    mount "/ddgc_static" => Plack::App::File->new(root => DDGC::Static::sharedir)->to_app;
    mount "/static" => Plack::App::File->new(root => $FindBin::Dir . '/../root/static')->to_app;
    mount "/media" => Plack::App::File->new(root => "$ddgc_home/media" )->to_app;
};

