package DDGC::Web::Table::Column;
# ABSTRACT: Abstraction for a column definition in DDGC::Web::Table

use Moose;
use DDGC::Web::Table::Cell;

has table => (
	is => 'ro',
	isa => 'DDGC::Web::Table',
	required => 1,
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

sub get_cell_from_row { my ( $self, $row ) = @_; if ($self->has_value_code) {
		for ($row->db) { # $_ == $row->db
			my ( $value, %args ) = $self->value_code->($self,$row);
			return DDGC::Web::Table::Cell->new(
				column => $self,
				row => $row,
				value => $value,
				%args,
			);
		}
	} elsif ($self->has_db_col) {
		return DDGC::Web::Table::Cell->new(
			column => $self,
			row => $row,
			value => $row->get_column($self->db_col),
		);
	} else {
		return DDGC::Web::Table::Cell->new(
			column => $self,
			row => $row,
			value => undef,
		);		
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
