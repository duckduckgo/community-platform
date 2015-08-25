package DDGC::Schema;

# ABSTRACT: DBIC Schema base class

use Moo;
extends 'DBIx::Class::Schema';

has app => (
    is => 'rw',
);

sub ddgc_config { $_[0]->app->config->{ddgc_config}; }

__PACKAGE__->load_namespaces();

1;
