package DDGC::Web::Controller::Comment;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('comment') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub add :Chained('base') :Args(2) {
    my ( $self, $c, $context, $context_id ) = @_;
	if ($c->req->params->{content}) {
		$c->d->add_comment($context, $context_id, $c->user, $c->req->params->{content});
	}
	if ($c->req->params->{from}) {
		$c->response->redirect($c->req->params->{from});
		return $c->detach;
	}
}

__PACKAGE__->meta->make_immutable;

1;
