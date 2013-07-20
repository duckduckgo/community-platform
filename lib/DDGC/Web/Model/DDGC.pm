package DDGC::Web::Model::DDGC;
# ABSTRACT: Adaptor model to connect DDGC to Catalyst

use Moose;
extends 'Catalyst::Model::Adaptor';

__PACKAGE__->config( class => 'DDGC' );

no Moose;
__PACKAGE__->meta->make_immutable;
