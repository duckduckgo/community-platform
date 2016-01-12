package DDGC::Web::Wizard::Base::ID;
# ABSTRACT:

use Moose;
extends 'DDGC::Web::Wizard';

has current_id => (
	is => 'rw',
	isa => 'Int',
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

sub next_rs { my $self = shift; die (ref $self)." needs sub next_rs" }
sub done_wizard { my $self = shift; die (ref $self)." needs sub done_wizard" }

sub next {
	my ( $self, $c ) = @_;
	$c->log->debug(__PACKAGE__.'->next') if $c->debug;
	my $next_rs = $self->next_rs($c);
	$self->count($next_rs->count);
	if ($self->count) {
		my $next = $next_rs->one_row; # using ->one_row will exhaust the underlying cursor, but doesn't look it's needed
		$self->current_id($next->id);
		my $url = $c->chained_uri(@{$next->u});
		$self->current_url($url);
		$c->res->redirect($url);
	} else {
		$self->done_wizard($c);
		$c->wiz_finished;
	}
	return;
}

1;
