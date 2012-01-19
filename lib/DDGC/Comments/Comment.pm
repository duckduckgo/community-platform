package DDGC::Comments::Comment;

use Moose;

has db => (
	isa => 'DDGC::DB::Result::Comment',
	is => 'ro',
	weak_ref => 1,
	required => 1,
	handles => [qw(
		id
		users_id
		context
		context_id
		content
		created
		updated
		parent_id
		user
		parent
	)],
	# DOES NOT HANDLE 'children'!!!! CAUSE WE HANDLE THAT ON OUR OWN!!!
);

has children => (
	isa => 'ArrayRef[DDGC::Comments::Comment]',
	is => 'ro',
	required => 1,
);

sub has_children {
	my ( $self ) = @_;
	return @{$self->children} ? 1 : 0;
}

has comments_context => (
	isa => 'DDGC::Comments',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

1;