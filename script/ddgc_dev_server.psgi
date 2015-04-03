#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use Plack::Builder;
use DDGC::Web;
use DDGC::Web::App::UserLoggedIn;
use DDGC::Web::Service::UserLoggedIn;

builder {
    enable 'Session', store => 'File', state => 'Cookie', secure => 2, httponly => 1, expires => 21600;

    mount '/userloggedin' => DDGC::Web::App::UserLoggedIn->to_app;
    mount '/userloggedin/json' => DDGC::Web::Service::UserLoggedIn->to_app;
    mount '/' => DDGC::Web->new->psgi_app;
};

