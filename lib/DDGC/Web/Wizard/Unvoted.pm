package DDGC::Web::Wizard::Unvoted;
# ABSTRACT: Unvoted tokens of a token domain in a language of a user

use Moose;
extends 'DDGC::Web::Wizard::Base::ID';

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

sub next_rs {
	my ( $self, $c ) = @_;
	$c->d->rs('Token::Language')->unvoted(
		$self->token_domain_id,
		$self->language_id,
		$c->user,
		$self->unwanted_ids,
	);
}

sub done_wizard {
	my ( $self, $c ) = @_;
	my $tdl = $c->d->rs('Token::Domain::Language')->search({
		token_domain_id => $self->token_domain_id,
		language_id => $self->language_id,
	})->one_row;
	$c->res->redirect($c->chained_uri(@{$tdl->u}));
}

no Moose;
__PACKAGE__->meta->make_immutable;
