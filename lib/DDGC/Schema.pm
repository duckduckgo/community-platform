package DDGC::Schema;

# ABSTRACT: DBIC Schema base class

use Moo;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces();

1;

