package DDGC::Schema::ResultSet;

use Moo;
extends 'DBIx::Class::ResultSet';

__PACKAGE__->load_components('Helper::ResultSet::Me');

1;
