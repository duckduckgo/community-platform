package DDGC::Web::View::JSON;
# ABSTRACT: Standard Catalyst JSON view

use Moose;
use MooseX::NonMoose;
extends 'Catalyst::View::JSON';

__PACKAGE__->config(
	expose_stash    => 'x',
);

no Moose;
__PACKAGE__->meta->make_immutable;
