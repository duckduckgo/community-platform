package DDGC::DB::ResultSet::Comment;
# ABSTRACT: Resultset class for comment entries

use Moose;
extends 'DBIx::Class::ResultSet';
use namespace::autoclean;

sub grouped_by_context {
	my ( $self ) = @_;
  my $comment_context_rs = $self->schema->resultset('Comment::Context')->search({},{
    select => [qw( latest_comment_id )],
    alias => 'comment_context',
  });
	$self->search_rs({
    'me.id' => { -in => $comment_context_rs->as_query },
  });
}

sub prefetch_all {
  my ( $self ) = @_;
  my $result_class = $self->result_class;
  my %prefetch = map {
    defined $result_class->context_config->{$_}->{prefetch} && $_ ne $result_class
      ? (
        $result_class->context_config->{$_}->{relation} => $result_class->context_config->{$_}->{prefetch}
      ) : ()
  } keys %{$self->result_class->context_config};
  $self->search_rs({},{
    prefetch => [qw( user ), \%prefetch],
  });
}

sub prefetch_tree {
  my ( $self ) = @_;
  my $next = my $start = {}; for (1..9) { my $children = ['user', {}]; $next->{children} = $children; $next = $children->[1] } $next->{children} = $next->{children}->[0];
  $self->search_rs({},{ prefetch => $start });
}

sub schema { shift->result_source->schema }

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
