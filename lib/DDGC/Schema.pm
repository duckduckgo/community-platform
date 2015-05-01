package DDGC::Schema;

# ABSTRACT: DBIC Schema base class

use Moo;
extends 'DBIx::Class::Schema';

has app => (
    is => 'rw',
);

__PACKAGE__->load_namespaces();

1;
