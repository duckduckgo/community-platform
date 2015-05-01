package DDGC::Schema::ResultSet;

# ABSTRACT: DBIC ResultSet base class

use Carp;
use Moo;
extends 'DBIx::Class::ResultSet';

__PACKAGE__->load_components(qw/
    Helper::ResultSet::Me
    Helper::ResultSet::Shortcut::HRI
/);

1;
