package DDGC::DB::ResultSet::Idea;
# ABSTRACT: Resultset class for idea entries

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub add_vote_count {
	my ( $self ) = @_;
	$self->search_rs({},{
		'+columns' => {
			vote_count => $self->correlated_vote_count,
		},
	});
}

sub correlated_vote_count {
  my ( $self ) = @_;
  $self->correlate('idea_votes')->count_rs->as_query;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
