package DDGC::Web::Wizard::UnvotedAll;
# ABSTRACT: All unvoted translations of the languages of a user

use Moose;
extends 'DDGC::Web::Wizard::Base::ID';

sub next_rs {
	my ( $self, $c ) = @_;
	$c->d->rs('Token::Language')->unvoted_all(
		$c->user,
		$self->unwanted_ids,
	);
}

sub done_wizard {
	my ( $self, $c ) = @_;
	$c->res->redirect($c->chained_uri('Translate','index'));
}

no Moose;
__PACKAGE__->meta->make_immutable;
