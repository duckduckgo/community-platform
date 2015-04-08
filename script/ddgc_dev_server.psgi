#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use Plack::Builder;
use DDGC::Web;
use DDGC::Web::App::Blog;
use DDGC::Web::Service::Blog;

builder {
    enable 'Session', store => 'File', state => 'Cookie', secure => 2, httponly => 1, expires => 21600;

    mount '/blog' => DDGC::Web::App::Blog->to_app;
    mount '/blog.json' => DDGC::Web::Service::Blog->to_app;
    mount '/' => DDGC::Web->new->psgi_app;
};

