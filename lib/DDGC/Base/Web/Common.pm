package DDGC::Base::Web::Common;

use Import::Into;

use strict;
use warnings;
use utf8;

use Dancer2;
use Dancer2::Plugin::DBIC;
use Dancer2::Plugin::Params::HashMultiValue;
use Dancer2::Plugin::DDGC::Config;
use Dancer2::Plugin::DDGC::Session;

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
            Dancer2::Plugin::Params::HashMultiValue
            Dancer2::Plugin::DDGC::Config
            Dancer2::Plugin::DDGC::Session
          /
        ) {
            $_->import::into($caller);
        }
    }
};

1;
