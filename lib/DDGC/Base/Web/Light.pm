package DDGC::Base::Web::Light;

# ABSTRACT: Base module for simple, unintegrated web apps

# Drops: Sessions, user integration
# Keeps: Database

use Import::Into;

use strict;
use warnings;
use utf8;

use Dancer2;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::RootURIFor;
use Dancer2::Plugin::Params::HashMultiValue;
use Dancer2::Plugin::DDGC::Config;
use Dancer2::Plugin::DDGC::SchemaApp;

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
            Dancer2::Plugin::DBIC
            Dancer2::Plugin::RootURIFor
            Dancer2::Plugin::Params::HashMultiValue
            Dancer2::Plugin::DDGC::SchemaApp
          /
        ) {
            $_->import::into($caller);
        }
    }
};

1;
