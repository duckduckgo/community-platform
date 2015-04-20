package DDGC::Base::Web::App;

use Import::Into;

use strict;
use warnings;
use utf8;

use DDGC::Base::Web::Common;
use Dancer2::Plugin::DDGC::App;

{   no warnings 'redefine';
    sub import {
        my ($caller, $filename) = caller;
        for (
          qw/
            DDGC::Base::Web::Common
            Dancer2::Plugin::DDGC::App
          /
        ) {
            $_->import::into($caller);
        }
    }
};

1;

