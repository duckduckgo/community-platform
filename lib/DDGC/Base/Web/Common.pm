package DDGC::Base::Web::Common;

# ABSTRACT: Base module with common configs / features for DDGC Apps and Services.

use Import::Into;

use strict;
use warnings;
use utf8;

use Dancer2;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::RootURIFor;
use Dancer2::Plugin::Params::HashMultiValue;
use Dancer2::Plugin::DDGC::Config;
use Dancer2::Plugin::DDGC::Session;
use Dancer2::Plugin::DDGC::Request;
use Dancer2::Plugin::DDGC::Markup;
use Dancer2::Plugin::DDGC::Validate;
use Dancer2::Plugin::DDGC::UserRole;
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
            Dancer2::Plugin::DBIC
            Dancer2::Plugin::RootURIFor
            Dancer2::Plugin::Params::HashMultiValue
            Dancer2::Plugin::DDGC::Config
            Dancer2::Plugin::DDGC::Session
            Dancer2::Plugin::DDGC::Request
            Dancer2::Plugin::DDGC::Markup
            Dancer2::Plugin::DDGC::Validate
            Dancer2::Plugin::DDGC::UserRole
            Dancer2::Plugin::DDGC::SchemaApp
          /
        ) {
            $_->import::into($caller);
        }
    }
};

1;
