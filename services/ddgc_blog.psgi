#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . '/../lib';

use Plack::Builder;
use DDGC::Util::Deployment;
use DDGC::Web::App::Blog;
use DDGC::Web::Service::Blog;

my $deploy = DDGC::Util::Deployment->new;

builder {
    enable 'Session',
        store => $deploy->session_store,
        state => $deploy->session_state;
    enable 'ReverseProxy';
    mount '/blog' => DDGC::Web::App::Blog->to_app;
};

