package DDGC::DB::Base::ResultSet;
# ABSTRACT: DBIC ResultSet base class

use Moose;
use namespace::autoclean;
use DateTime;
use DateTime::Format::Pg;
use Try::Tiny;

extends 'DBIx::Class::ResultSet';

__PACKAGE__->load_components(qw/
    Helper::ResultSet::Me
    Helper::ResultSet::Shortcut
    Helper::ResultSet::CorrelateRelationship
    Helper::ResultSet::SetOperations
    Helper::ResultSet::OneRow
/);

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

sub join_for_activity_meta {
  my ( $self, $column ) = @_;
  join( '', map { sprintf ':%s:', $_ } $self->columns( [$column] )->all );
}

sub last_modified {
  my ( $self ) = @_;
  my $last_modified;

  try {
    $last_modified = DateTime::Format::Pg->parse_datetime(
      $self->get_column('updated')->max
    )->truncate( to => 'second' );
  };

  return $last_modified // DateTime->new( year => 1970 );
}

1;
