package DDGC::Base::Web::App;

use Import::Into;

use strict;
use warnings;
use utf8;

use DDGC::Base::Web::Common;

{   no warnings 'redefine';
    sub import {
        my ($caller, $filename) = caller;
        for (
          qw/
            DDGC::Base::Web::Common
          /
        ) {
            $_->import::into($caller);
        }
    }
};

1;

