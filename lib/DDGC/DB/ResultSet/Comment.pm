package DDGC::DB::ResultSet::Comment;
# ABSTRACT: Resultset class for comment entries

use Moose;
extends 'DBIx::Class::ResultSet';
use namespace::autoclean;

sub grouped_by_context {
	my ( $self ) = @_;
	$self->search({},{
		'+columns' => [
			{ max => 'created', -as => 'latest_comment_date' },
			{ min => 'created', -as => 'first_comment_date' },
		],
		group_by => [qw( context context_id )],
	});
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
