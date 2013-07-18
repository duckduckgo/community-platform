package DDGC::Web::View::JSON;
# ABSTRACT: Standard Catalyst JSON view

use Moose;
extends 'Catalyst::View::JSON';

__PACKAGE__->config(
	expose_stash    => 'x',
);

1;
