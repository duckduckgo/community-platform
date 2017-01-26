package DDGC::Base::Web::LightService;

# ABSTRACT: Base module for simple, unintegrated web services

# Drops: Sessions, user integration
# Keeps: Database, serializer

use Import::Into;

use strict;
use warnings;
use utf8;

use DDGC::Base::Web::Light;
use Dancer2::Plugin::DDGC::Service;
use Dancer2::Plugin::DDGC::Bailout;

{   no warnings 'redefine';
    sub import {
        my ($caller, $filename) = caller;
        for (
          qw/
            strict
            warnings
            utf8
            Dancer2
          /
        ) {
            $_->import::into($caller);
        }
        Dancer2::Plugin::DDGC::Config->import::into( $caller, 'nosession' );
        for (
          qw/
            DDGC::Base::Web::Light
            Dancer2::Plugin::DDGC::Service
            Dancer2::Plugin::DDGC::Bailout
          /
        ) {
            $_->import::into($caller);
        }
    }
};

1;
