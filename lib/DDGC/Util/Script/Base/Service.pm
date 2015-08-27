use strict;
use warnings;
package DDGC::Util::Script::Base::Service;

# ABSTRACT: Common elements of service architecture based script modules

use Moo::Role;
use DDGC::Base::Web::Common;

has ddgc_config => (
    is      => 'ro',
    lazy    => 1,
    builder => '_build_ddgc_config',
);
sub _build_ddgc_config {
    config->{ddgc_config};
}

1;
