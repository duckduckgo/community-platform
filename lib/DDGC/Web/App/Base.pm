package DDGC::Web::App::Base;

use Import::Into;

use strict;
use warnings;
use utf8;

use Dancer2;
use Dancer2::Plugin::DBIC;
use DDGC::Web::Plugin::Config;
use DDGC::Web::Plugin::Session;

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
            DDGC::Web::Plugin::Config
            DDGC::Web::Plugin::Session
          /
        ) {
            $_->import::into($caller);
        }
    }
};

1;
