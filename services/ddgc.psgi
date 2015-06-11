#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . '/../lib';

use Plack::Builder;
use DDGC::Util::Deployment;
use DDGC::Web;

my $deploy = DDGC::Util::Deployment->new;

builder {
    enable 'Session',
        store => $deploy->session_store,
        state => $deploy->session_state;
    mount '/' => DDGC::Web->apply_default_middlewares( DDGC::Web->new->psgi_app(@_) ) ;
};

