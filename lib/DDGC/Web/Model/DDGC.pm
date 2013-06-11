package DDGC::Web::Model::DDGC;
# ABSTRACT: 

use Moose;
extends 'Catalyst::Model::Adaptor';

__PACKAGE__->config( class => 'DDGC' );

1;