package DDGC::Base::Web::Service;

# ABSTRACT: Base module for Services

use Import::Into;

use strict;
use warnings;
use utf8;

use DDGC::Base::Web::Common;
use Dancer2::Plugin::DDGC::Service;
use Dancer2::Plugin::DDGC::Bailout;

{   no warnings 'redefine';
    sub import {
        my ($caller, $filename) = caller;
        for (
          qw/
            DDGC::Base::Web::Common
            Dancer2::Plugin::DDGC::Service
            Dancer2::Plugin::DDGC::Bailout
          /
        ) {
            $_->import::into($caller);
        }
    }
};

1;
