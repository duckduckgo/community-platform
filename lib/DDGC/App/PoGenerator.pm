package DDGC::App::PoGenerator;

use Moose;
use DDGC;

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

has _ddgc {
	traits => [qw( NoGetopt )],
	isa => 'DDGC',
	is => 'ro',
	default => sub { DDGC->new };
}

1;