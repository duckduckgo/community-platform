package DDGC::Wizard::Unvoted;

use Moose;
use MooseX::Storage;
#extends 'DDGC::Wizard';

with Storage('format' => 'Storable');

##################

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

################


has token_domain_id => (
	is => 'ro',
	required => 1,
	isa => 'Str',
);

has language_id => (
	is => 'ro',
	required => 1,
	isa => 'Str',
);

has current_id => (
	is => 'rw',
	isa => 'Str',
);

has count => (
	is => 'rw',
	isa => 'Int',
);

has unwanted_ids => (
	is => 'rw',
	isa => 'ArrayRef',
	default => sub {[]},
);

sub next {
	my ( $self, $c ) = @_;
	$c->log->debug(__PACKAGE__.'->next') if $c->debug;
	my $next_rs = $c->d->rs('Token::Language')->unvoted(
		$self->token_domain_id,
		$self->language_id,
		$c->user->id,
		$self->unwanted_ids,
	);
	$self->count($next_rs->count);
	if ($self->count) {
		my $next = $next_rs->first;
		$self->current_id($next->id);
		my $url = $c->chained_uri(@{$next->u});
		$self->current_url($url);
		$c->res->redirect($url);
	} else {
		my $tdl = $c->d->rs('Token::Domain::Language')->search({
			token_domain_id => $self->token_domain_id,
			language_id => $self->language_id,
		})->first;
		$c->res->redirect($c->chained_uri(@{$tdl->u}));
		$c->wiz_finished;
	}
	return;
}

1;