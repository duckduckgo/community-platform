package DDGC::DB::ResultSet::Idea;
# ABSTRACT: Resultset class for idea entries

use Moose;
extends 'DBIx::Class::ResultSet';
use namespace::autoclean;

sub schema { shift->result_source->schema }

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
