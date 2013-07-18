package DDGC::Wizard::UntranslatedAllDomain;
# ABSTRACT: All untranslated tokens of a domain of the languages of a user

use Moose;
extends 'DDGC::Wizard::Base::ID';

has token_domain_id => (
	is => 'ro',
	required => 1,
	isa => 'Str',
);

sub next_rs {
	my ( $self, $c ) = @_;
	$c->d->rs('Token::Language')->untranslated_all(
		$c->user,
		$self->unwanted_ids,
		$self->token_domain_id,
	);
}

sub done_wizard {
	my ( $self, $c ) = @_;
	$c->res->redirect($c->chained_uri('Translate','index'));
}

1;