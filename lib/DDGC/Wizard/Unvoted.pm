package DDGC::Wizard::Unvoted;

use Moose;
extends 'DDGC::Wizard';

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