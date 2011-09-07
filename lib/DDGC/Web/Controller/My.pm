package DDGC::Web::Controller::My;
use Moose;
use namespace::autoclean;

use DDGC::Config;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('my') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub logout :Chained('base') :Args(0) :Global {
    my ( $self, $c ) = @_;
	$c->logout;
	$c->response->redirect($c->uri_for($self->action_for("login")));
}

sub logged_in :Chained('base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->uri_for($self->action_for("login")));
		return $c->detach;
	}
}

sub logged_out :Chained('base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if ($c->user) {
		$c->response->redirect($c->uri_for($self->action_for("account")));
		return $c->detach;
	}
}

sub account :Chained('logged_in') :Args(0) {
    my ( $self, $c ) = @_;
}

sub forgotpw :Chained('logged_out') :Args(0) {
    my ( $self, $c ) = @_;
}

sub login :Chained('logged_out') :Args(0) {
    my ( $self, $c ) = @_;

	$c->stash->{no_login} = 1;
	
	if ( my $username = $c->req->params->{username} and my $password = $c->req->params->{password} ) {
		if ($c->authenticate({
			username => $username,
			password => $password,
		}, 'users')) {
			$c->response->redirect($c->uri_for($self->action_for('account')));
		} else {
			$c->stash->{login_failed} = 1;
		}
	}
}

sub register :Chained('logged_out') :Args(0) {
    my ( $self, $c ) = @_;

	$c->stash->{no_login} = 1;

	return $c->detach if !$c->req->params->{register};
	
	if (!$c->validate_captcha($c->req->params->{captcha})) {
		$c->stash->{wrong_captcha} = 1;
		return $c->detach;
	}

	my $error = 0;
	
	if ($c->req->params->{repeat_password} ne $c->req->params->{password}) {
		$c->stash->{password_different} = 1;
		$error = 1;
	}

	if (!defined $c->req->params->{password} or length($c->req->params->{password}) < 3) {
		$c->stash->{password_too_short} = 1;
		$error = 1;
	}

	if (!defined $c->req->params->{username} or $c->req->params->{username} eq '') {
		$c->stash->{need_username} = 1;
		$error = 1;
	}

	my $username = $c->req->params->{username};
	my $password = $c->req->params->{password};

	my $count = $c->model('ProsodyDB::Prosody')->search({
		host => DDGC::Config::prosody_userhost(),
		user => $username,
	})->count;
	
	if ($count > 0) {
		$c->stash->{user_exist} = $username;
		$error = 1;
	} else {
		$c->stash->{username} = $c->req->params->{username};
	}
	
	return $c->detach if $error;

	# CREATE TABLE `prosody` (`host` TEXT, `user` TEXT, `store` TEXT, `key` TEXT, `type` TEXT, `value` TEXT);
	# INSERT INTO "prosody" VALUES('test.domain','testone','accounts','password','string','testpass');

	my $user;
	$user = $c->model('ProsodyDB::Prosody')->create({
		host => DDGC::Config::prosody_userhost(),
		user => $username,
		store => 'accounts',
		key => 'password',
		type => 'string',
		value => $password,
	});
	
	if (!$user) {
		$c->stash->{register_failed} = 1;
		return $c->detach;
	}

	$c->response->redirect($c->uri_for($self->action_for('login')));

}

__PACKAGE__->meta->make_immutable;

1;
