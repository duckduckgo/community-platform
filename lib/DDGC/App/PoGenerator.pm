package DDGC::App::PoGenerator;

use Moose;

with qw(
	MooseX::Getopt
);

has targetdir => (
	isa => 'Str',
	is => 'ro',
	required => 1,
);

has context => (
	isa => 'Str',
	is => 'ro',
	required => 1,
);

has auto => (
	isa => 'Bool',
	is => 'ro',
	default => sub { 0 },
);

has update => (
	isa => 'Bool',
	is => 'ro',
	default => sub { 1 },
);

has fallback => (
	isa => 'Bool',
	is => 'ro',
	default => sub { 0 },
);

1;