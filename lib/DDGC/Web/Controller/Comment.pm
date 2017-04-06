package DDGC::Web::Controller::Comment;
# ABSTRACT:

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Try::Tiny;

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
	$c->add_bc('Latest comments', $c->chained_uri('Comment','latest'));
}

sub delete : Chained('do') Args(1) {
	my ( $self, $c, $id ) = @_;
	my $comment = $c->d->rs('Comment')->prefetch_all->find($id);
	return unless $comment;
	return unless $c->user && ($c->user->admin || $c->user->id == $comment->user->id);
	$c->require_action_token;
	if ($comment->context eq 'DDGC::DB::Result::Thread' && !$comment->parent_id) {
		$c->response->redirect($c->chained_uri(@{$comment->get_context_obj->u_delete}));
		return $c->detach;
	}
	$c->d->db->txn_do(sub {
		if ($comment->children->count) {
			my $deleted_user = $c->d->db->resultset('User')->single({
				username => $c->d->config->deleted_account,
			});
			$comment->content('This comment has been deleted.');
			$comment->users_id( defined $deleted_user ? $deleted_user->id : undef );
			$comment->update;
		} else {
			$comment->delete;
		}
	});
	my $redirect = $c->req->headers->referrer || '/';
	$c->response->redirect($redirect);
	return $c->detach;
}

sub add :Chained('base') :Args(2) {
	my ( $self, $c, $context, $context_id ) = @_;
	return unless $c->user || ! $c->stash->{no_reply};
	return if ( $context eq 'DDGC::DB::Result::Thread' || $context eq 'DDGC::DB::Result::Idea' || $context eq 'DDGC::DB::Result::User::Blog' );
	$c->require_action_token;
	unless ($c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
	if ($c->req->params->{content}) {
		my $err;
		try {
			$c->d->add_comment($context, $context_id, $c->user, $c->req->params->{content});
		}
		catch {
			$err = 1;
		};
		if ($err) {
			$c->session->{error_msg} = "We were unable to post your comment. Have you posted already in the last few minutes? If so, please <a href='javascript:history.back()'>go back</a> and try again in a short while.";
			$c->response->redirect($c->chained_uri('Root','error'));
			return $c->detach;
		}
	}
	if ($c->req->params->{from}) {
		$c->response->redirect($c->req->params->{from});
		return $c->detach;
	}
}

__PACKAGE__->meta->make_immutable;

1;
