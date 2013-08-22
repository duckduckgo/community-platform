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
	$self->search({
    id => { -in => $comment_context_rs->as_query },
  });
}

sub schema { shift->result_source->schema }

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
