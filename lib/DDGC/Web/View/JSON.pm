package DDGC::Web::View::JSON;
# ABSTRACT: 

use Moose;
extends 'Catalyst::View::JSON';

__PACKAGE__->config(
	expose_stash    => 'x',
);

1;
