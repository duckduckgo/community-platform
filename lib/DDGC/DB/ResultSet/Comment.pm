package DDGC::DB::ResultSet::Comment;
# ABSTRACT: Resultset class for comment entries

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub grouped_by_context {
	my ( $self ) = @_;
  my $comment_context_rs = $self->schema->resultset('Comment::Context')->search_rs({},{
    select => [qw( latest_comment_id )],
    alias => 'comment_context',
  });
	$self->search_rs({
    $self->me.'id' => { -in => $comment_context_rs->as_query },
  },{
    '+columns' => {
      comments_count => $self->schema->resultset('Comment')->search_rs({
        'comments_count.context' => { -ident => $self->me.'context' },
        'comments_count.context_id' => { -ident => $self->me.'context_id' },
      },{
        alias => 'comments_count',
      })->count_rs->as_query
    },
  });
}

sub prefetch_all {
  my ( $self ) = @_;
  $self->search_rs({},{
    prefetch => [qw( user ), $self->prefetch_context_config],
  });
}

sub prefetch_tree {
  my ( $self ) = @_;
  my $next = my $start = {}; for (1..9) { my $children = ['user', {}]; $next->{children} = $children; $next = $children->[1] } $next->{children} = $next->{children}->[0];
  $self->search_rs({},{ prefetch => ['parent',$start] });
}

sub schema { shift->result_source->schema }

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
