package DDGC::Web::Table::Row;
# ABSTRACT: Abstraction for a row in DDGC::Web::Table

use Moose;

has table => (
	is => 'ro',
	isa => 'DDGC::Web::Table',
	required => 1,
);

has db => (
	is => 'ro',
	required => 1,
	handles => [qw(
		get_column
	)],
);

has key => (
	is => 'ro',
	isa => 'Str',
	lazy => 1,
	default => sub { $_[0]->table->key.'_row_'.$_[0]->db->id },
);

has cells => (
	is => 'ro',
	isa => 'ArrayRef[DDGC::Web::Table::Cell]',
	lazy => 1,
	default => sub {
		my ( $self ) = @_;
		[map { $_->get_cell_from_row($self) } @{ $self->table->cols }]
	},
);

no Moose;
__PACKAGE__->meta->make_immutable;
