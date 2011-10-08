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

# NOT IMPLEMENTED YET
has fallback => (
	isa => 'Bool',
	is => 'ro',
	default => sub { 0 },
);

has _ddgc => (
	traits => [qw( NoGetopt )],
	isa => 'DDGC',
	is => 'ro',
	default => sub { DDGC->new },
);
sub d { shift->_ddgc }

sub BUILD {
	my ( $self ) = @_;
	my $context = $self->d->rs('Token::Context')->search({ key => $self->context })->first;
	die "[".__PACKAGE__."] no context found" unless $context;
	for ($context->token_context_languages->search_related('token_languages')->all) {
		$_->auto_use if ($self->auto && !$_->translation);
		
	}
}

1;