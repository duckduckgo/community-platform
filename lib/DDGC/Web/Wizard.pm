package DDGC::Web::Wizard;
# ABSTRACT: Wizard base class

use Moose;
use MooseX::Storage;
with Storage('format' => 'Storable');

has name => (
	is => 'ro',
	lazy_build => 1,
);

sub _build_name {
	my ( $self ) = @_;
	my $class = (ref $self) ? (ref $self) : ($self);
	$class =~ s/^DDGC::Wizard:://;
	return $class;
}

has inside => (
	is => 'rw',
	default => sub { 1 },
);

has current_url => (
	is => 'rw',
	default => sub { '' },
);

has next_step => (
	is => 'rw',
	default => sub { 0 },
);

sub check {
	my ( $self, $c ) = @_;
	$c->log->debug((ref $self).'->check') if $c->debug;
	$self->inside($c->req->uri eq $self->current_url);
}

sub post_check {
	my ( $self, $c ) = @_;
	$c->log->debug((ref $self).'->post_check') if $c->debug;
	if ($self->next_step) {
		$self->next_step(0);
		$self->next($c);
	}
}

1;