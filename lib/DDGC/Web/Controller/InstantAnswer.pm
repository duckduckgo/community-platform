package DDGC::Web::Controller::InstantAnswer;
# ABSTRACT: Instant Answer Pages

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('instantanswer') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	# Retrieve / stash all IAs for index page here?
}

sub ia_base :Chained('base') :PathPart('view') :CaptureArgs(1) {
	my ( $self, $c, $answer_id ) = @_;

	$c->stash->{ia} = $c->d->rs('InstantAnswer')->find($answer_id);

	unless ($c->stash->{ia}) {
		$c->response->redirect($c->chained_uri('InstantAnswer','index',{ instant_answer_not_found => 1 }));
		return $c->detach;
	}

	use DDP;
	$c->stash->{ia_pretty} = p $c->stash->{ia};
}

sub ia  :Chained('ia_base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
}


no Moose;
__PACKAGE__->meta->make_immutable;

