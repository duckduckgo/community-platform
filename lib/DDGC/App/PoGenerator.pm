package DDGC::App::PoGenerator;
# ABSTRACT: Application for generating po files for a token domain

use Moose;
use DDGC;
use File::Spec;
use File::Which;
use IO::All -utf8;
use Path::Class;
use Carp;
use DateTime;
use DateTime::Format::Strptime;

our $VERSION ||= '0.0development';

with qw(
	MooseX::Getopt
);

has targetdir => (
	isa => 'Str',
	is => 'ro',
	required => 1,
);

has domain => (
	isa => 'Str',
	is => 'ro',
	predicate => 'has_domain',
);

has alldomain => (
	isa => 'Bool',
	is => 'ro',
	default => sub { 0 },
);

has fallback => (
	isa => 'Bool',
	is => 'ro',
	default => sub { 1 },
);

has _ddgc => (
	traits => [qw( NoGetopt )],
	isa => 'DDGC',
	is => 'ro',
	default => sub { DDGC->new },
);
sub d { shift->_ddgc }

has _dir => (
	traits => [qw( NoGetopt )],
	isa => 'Str',
	is => 'ro',
	lazy_build => 1,
);

sub _build__dir {
	my ( $self ) = @_;
	return $self->targetdir if File::Spec->file_name_is_absolute($self->targetdir);
	return File::Spec->rel2abs($self->targetdir);
}

sub BUILD {
	my ( $self ) = @_;
	$self->error("po2json not found - DDG::Translate installed?") unless which('po2json');
	$self->error("msgfmt not found - gettext installed?") unless which('msgfmt');
	$self->error($self->_dir." is not writeable") unless -w $self->_dir;
	if ($self->has_domain) {
		$self->error("got domain and alldomain at once") if $self->alldomain;
		my $tc = $self->d->rs('Token::Domain')->search({ key => $self->domain })->one_row;
		$self->error("no domain found") unless $tc;
		$self->generate_pos_for_domain($tc,$self->_dir);
	} elsif ($self->alldomain) {
		for ($self->d->rs('Token::Domain')->search({})->all) {
			$self->generate_pos_for_domain($_,$self->_dir);
		}
	} else {
		$self->error("no domain given and no alldomain")
	}
}

sub generate_pos_for_domain {
	my ( $self, $token_domain, $dir ) = @_;
	$token_domain->generate_pos($dir,'DDGC::App::PoGenerator '.$VERSION,$self->fallback);
}

sub error { die "[".(ref shift)."] ".shift }

1;
