#!/usr/bin/env perl

# Development server builder.
# See ddgc_dev_server.sh

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use Plack::Builder;
use Plack::Session::State::Cookie;
use DDGC::Web;
use DDGC::Web::App::Blog;
use DDGC::Web::Service::Blog;

builder {
    enable 'Session', store => 'File', state => Plack::Session::State::Cookie->new(
        secure => 0,
        httponly => 1,
        expires => 21600,
        session_key => 'ddgc_session',
    );
    enable 'Debug', panels => [
        qw/ Environment Response Parameters Timer Memory Session DBITrace CatalystLog /
    ];
    mount '/blog' => DDGC::Web::App::Blog->to_app;
    mount '/blog.json' => DDGC::Web::Service::Blog->to_app;
    mount '/' => DDGC::Web->new->psgi_app;
};

