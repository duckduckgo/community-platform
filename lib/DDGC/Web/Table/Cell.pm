package DDGC::Web::Table::Cell;
# ABSTRACT: Abstraction for a cell in DDGC::Web::Table

use Moose;

has row => (
	is => 'ro',
	isa => 'DDGC::Web::Table::Row',
	required => 1,
	handles => [qw(
		db
	)]
);

has value => (
	is => 'ro',
	required => 1,
);

sub has_value { defined $_[0]->value ? 1 : 0 }

has link => (
	is => 'ro',
	predicate => 'has_link',
);

has column => (
	is => 'ro',
	isa => 'DDGC::Web::Table::Column',
	required => 1,
	handles => [qw(
		table
		label
		has_label
		db_col
		has_db_col
		value_code
		has_value_code
		template
		has_template
		i
		has_i
		i_args
	)],
);

no Moose;
__PACKAGE__->meta->make_immutable;
