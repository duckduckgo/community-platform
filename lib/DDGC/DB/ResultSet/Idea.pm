package DDGC::DB::ResultSet::Idea;
# ABSTRACT: Resultset class for idea entries

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

# sub add_vote_count {
# 	my ( $self ) = @_;
# 	$self->search({},{
# 		'+columns' => {
# 			vote_count => \[ $self->me.'old_vote_count + COUNT(idea_votes.id)' ],
# 		},
# 		join => 'idea_votes',
# 	});
# }

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
