package DDGC::DB::Base::ResultSet;

use Moose;
extends 'DBIx::Class::ResultSet';
use namespace::autoclean;

sub ddgc { shift->result_source->schema->ddgc }
sub schema { shift->result_source->schema }

sub ids {
  my ( $self ) = @_;
  map { $_->id } $self->search({},{
    columns => [qw( id )],
  })->all;
}

1;