package DDGC::DB::ResultSet::Idea;
# ABSTRACT: Resultset class for idea entries

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub add_vote_count {
	my ( $self ) = @_;
	$self->search_rs({},{
		'+columns' => {
			total_vote_count => $self->correlated_total_vote_count,
		},
	});
}

sub prefetch_all {
  my ( $self ) = @_;
  $self->search_rs({},{
    prefetch => [qw( user )],
  });
}

sub correlated_vote_count {
  my ( $self ) = @_;
  $self->correlate('idea_votes')->count_rs->as_query;
}

sub correlated_total_vote_count {
  my ( $self ) = @_;
  my ( $new_vote_sql, @new_vote_bind) = @{${$self->correlated_vote_count}};  
  return \[ "$new_vote_sql + ".$self->me."old_vote_count", @new_vote_bind ]
}

1;