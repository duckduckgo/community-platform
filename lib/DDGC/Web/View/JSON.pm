package DDGC::Web::View::JSON;
# ABSTRACT: 

use strict;
use base 'Catalyst::View::JSON';

__PACKAGE__->config(
	expose_stash    => 'x',
);

1;
