package DDGC::Wizard::UntranslatedAll;

use Moose;
extends 'DDGC::Wizard';

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

sub next {
	my ( $self, $c ) = @_;
	$c->log->debug(__PACKAGE__.'->next') if $c->debug;
	my $next_rs = $c->d->rs('Token::Language')->untranslated_all(
		$c->user,
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
		$c->res->redirect($c->chained_uri('Translate','index'));
		$c->wiz_finished;
	}
	return;
}

1;