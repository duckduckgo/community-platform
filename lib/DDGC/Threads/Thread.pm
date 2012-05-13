package DDGC::Comments::Thread;

use Moose;

has db => (
	isa => 'DDGC::DB::Result::Thread',
	is => 'ro',
	weak_ref => 1,
	required => 1,
	handles => [qw(
		id
        title
		users_id
        category
	)],
);

has posts => (
	isa => 'ArrayRef[DDGC::Comments::Comment]',
	is => 'ro',
	required => 1,
);

sub has_posts {
	my ( $self ) = @_;
	return @{$self->posts} ? 1 : 0;
}

1;
