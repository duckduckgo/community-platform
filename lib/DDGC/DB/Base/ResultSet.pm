package DDGC::DB::Base::ResultSet;

use Moose;
use namespace::autoclean;

extends qw(
  DBIx::Class::ResultSet
  DBIx::Class::Helper::ResultSet::Shortcut::Limit
);

sub ddgc { shift->result_source->schema->ddgc }
sub schema { shift->result_source->schema }

sub ids {
  my ( $self ) = @_;
  map { $_->id } $self->search({},{
    columns => [qw( id )],
  })->all;
}

sub paging {
  my ( $self, $page, $rows ) = @_;
  return $self->search(undef, {
    page => $page,
  })->limit($rows);
}

1;
