package DDGC::Web::Table::Column;
# ABSTRACT: Abstraction for a column definition in DDGC::Web::Table

use Moose;
use DDGC::Web::Table::Cell;

has table => (
	is => 'ro',
	isa => 'DDGC::Web::Table',
	required => 1,
);

has u_cell => (
	is => 'ro',
	isa => 'CodeRef',
	predicate => 'has_u_cell',
);

has label => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_label',
);

has template => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_template',
);

has i => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_i',
);

has i_args => (
	is => 'ro',
	isa => 'HashRef',
	default => sub {{}},	
);

has value_code => (
	is => 'ro',
	isa => 'CodeRef',
	predicate => 'has_value_code',
);

has db_col => (
	is => 'ro',
	isa => 'Str',
	predicate => 'has_db_col',
);

sub get_cell_from_row {
	my ( $self, $row ) = @_;
	my $link;
	if ($self->has_u_cell) {
		for ($row->db) {
			$link = $self->u_cell->($self,$row);
		}
	}
	if (!$link && $self->table->has_u_row) {
		for ($row->db) {
			$link = $self->table->u_row->($self,$row);
		}
	}	
	my %args = (
		$link ? ( link => $link ) : (),
		column => $self,
		row => $row,
	);
	if ($self->has_value_code) {
		for ($row->db) { # $_ == $row->db
			my ( $value, %extra_args ) = $self->value_code->($self,$row);
			return DDGC::Web::Table::Cell->new( %args,
				value => $value,
				%extra_args,
			);
		}
	} elsif ($self->has_db_col) {
		return DDGC::Web::Table::Cell->new( %args,
			value => $row->get_column($self->db_col),
		);
	} else {
		return DDGC::Web::Table::Cell->new( %args,
			value => undef,
		);		
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
