package DDGC::DB::Base::ResultSet;
# ABSTRACT: DBIC ResultSet base class

use Moose;
use namespace::autoclean;

extends qw(
  DBIx::Class::ResultSet
  DBIx::Class::Helper::ResultSet::Me
  DBIx::Class::Helper::ResultSet::Shortcut
  DBIx::Class::Helper::ResultSet::CorrelateRelationship
  DBIx::Class::Helper::ResultSet::SetOperations
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

sub prefetch_context_config {
  my ( $self, $result_class, %opts ) = @_;
  $result_class = $self->result_class unless defined $result_class;
  my %prefetch = map {
    defined $result_class->context_config(%opts)->{$_}->{prefetch} && $_ ne $result_class
      ? (
        $result_class->context_config(%opts)->{$_}->{relation} => $result_class->context_config(%opts)->{$_}->{prefetch}
      ) : ()
  } keys %{$self->result_class->context_config};
  return \%prefetch;
}

sub all_ref {
  [ $_[0]->all ];
}

1;
