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
use DDGC::Web::Service::ActivityFeed;
use Plack::App::File;
use Plack::Session::State::Cookie;
use Plack::Session::Store::File;

my $ddgc_home = (getpwuid($<))[7] . '/ddgc';
my $ddgc_sessions = "$ddgc_home/sessions/";
mkdir $ddgc_sessions unless -d $ddgc_sessions;

builder {
    enable 'StackTrace', force => 1;
    enable 'Session',
        store => Plack::Session::Store::File->new(
            dir => $ddgc_sessions,
        ),
        state => Plack::Session::State::Cookie->new(
            secure => 0,
            httponly => 1,
            expires => 21600,
            session_key => 'ddgc_session',
        );
    if ( !$ENV{DDGC_NO_DEBUG_PANEL} ) {
        enable 'Debug', panels => [
            qw/ Environment Response Parameters Timer Session DBITrace CatalystLog /
        ];
    }
    mount '/blog' => DDGC::Web::App::Blog->to_app;
    mount '/blog.json' => DDGC::Web::Service::Blog->to_app;
    mount '/activityfeed.json' => DDGC::Web::Service::ActivityFeed->to_app;
    mount '/' => DDGC::Web->new->psgi_app;
    mount "/static" => Plack::App::File->new(root => $FindBin::Dir . '/../root/static')->to_app;
    mount "/media" => Plack::App::File->new(root => "$ddgc_home/media" )->to_app;
    mount "/thumbnail" => Plack::App::File->new( root => "$ddgc_home/media/thumbnail" )->to_app;
    mount "/generated_css" => Plack::App::File->new( root => "$ddgc_home/cache/generated_css" )->to_app;
    mount "/generated_images" => Plack::App::File->new( root => "$ddgc_home/cache/generated_images" )->to_app;
};

