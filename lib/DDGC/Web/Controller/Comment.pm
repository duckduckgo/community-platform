package DDGC::Web::Controller::Comment;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('comment') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub do :Chained('base') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub latest :Chained('do') :Args(0) {
    my ( $self, $c ) = @_;
	$c->pager_init($c->action,20);
	$c->stash->{latest_comments} = [($c->d->rs('Comment')->search({},{
		order_by => 'me.created',
		page => $c->stash->{page},
		rows => $c->stash->{pagesize},
	}))];
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
