package DDGC::Web::Controller::Admin::User;
# ABSTRACT: User administration web controller class

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base :Chained('/admin/base') :PathPart('user') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('User management', $c->chained_uri('Admin::User','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;
}

sub user_base :Chained('base') :PathPart('view') :CaptureArgs(1) {
	my ( $self, $c, $username ) = @_;
	$c->stash->{user} = $c->d->find_user($username);
	unless ($c->stash->{user}) {
		$c->response->redirect($c->chained_uri('Admin::User','index',{ user_not_found => 1 }));
		return $c->detach;
	}
	for (keys %{$c->d->all_roles}) {
		if (defined $c->req->params->{$_}) {
			if ($c->req->param($_)) {
				if ($_ eq 'patron') {
					$c->stash->{user}->reset_notifications_patron_role;
				}
				$c->stash->{user}->add_flag($_);
			} else {
				$c->stash->{user}->del_flag($_);
			}
		}
	}
	if (defined $c->req->params->{ghosted}) {
		$c->req->param('ghosted')
			? $c->stash->{user}->ghosted(1)
			: $c->stash->{user}->ghosted(0)
	}
	if (defined $c->req->params->{ignore}) {
		$c->req->param('ignore')
			? $c->stash->{user}->ignore(1)
			: $c->stash->{user}->ignore(0)
	}
	if (defined $c->req->params->{changepass} && defined $c->req->params->{newpass} && length($c->req->params->{newpass})) {
		if ($c->req->params->{newpass} eq $c->req->params->{newpass2}) {
			$c->d->update_password($c->stash->{user}->username,$c->req->params->{newpass});
		}
	}
	$c->stash->{user}->update;
	$c->add_bc($c->stash->{user}->username, $c->chained_uri('Admin::User','index'));
}

sub user :Chained('user_base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;
}

no Moose;
__PACKAGE__->meta->make_immutable;
