#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use Plack::Builder;
use DDGC::Web;
use Plack::App::Proxy;

builder {
    mount '/' => DDGC::Web->new->psgi_app;
    mount '/screenshot' => Plack::App::Proxy->new(remote => "http://ddh5.duckduckgo.com:5000/screenshot")->to_app;
}
