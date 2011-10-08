package DDGC::Web::Controller::My;
use Moose;
use namespace::autoclean;

use DDGC::Config;
use DDGC::User;
use Email::Valid;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('my') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	$c->stash->{headline_template} = 'headline/my.tt';
	push @{$c->stash->{template_layout}}, 'centered_content.tt';
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
	push @{$c->stash->{template_layout}}, 'my/base.tt';
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

sub languages :Chained('logged_in') :Args(0) {
    my ( $self, $c ) = @_;
	$c->stash->{languages} = [$c->model('DB::Language')->search({})->all];
	if ($c->req->params->{add_user_language}) {
		$c->user->db->update_or_create_related('user_languages',{
			grade => $c->req->params->{grade},
			language_id => $c->req->params->{language_id},
		},{
			key => 'user_language_language_id_username',
		});
	}
}

sub apps :Chained('logged_in') :Args(0) {
    my ( $self, $c ) = @_;
}

sub timeline :Chained('logged_in') :Args(0) {
    my ( $self, $c ) = @_;
}

sub email :Chained('logged_in') :Args(0) {
	my ( $self, $c, ) = @_;

	return $c->detach if !$c->req->params->{save_email};

	if (!$c->validate_captcha($c->req->params->{captcha})) {
		$c->stash->{wrong_captcha} = 1;
		return;
	}

	my $email = $c->req->params->{emailaddress};

	if ( !$email || !Email::Valid->address($email) ) {
		$c->stash->{no_valid_email} = 1;
		return;
	}

	$c->user->data({}) if !$c->user->data;
	$c->user->data->{email} = $email;
	$c->user->update();

	$c->response->redirect($c->chained_uri('My','account'));
	return $c->detach;
}


sub public :Chained('logged_in') :Args(0) {
    my ( $self, $c ) = @_;

	return $c->detach if !($c->req->params->{hide_profile} || $c->req->params->{show_profile});
	
	if (!$c->validate_captcha($c->req->params->{captcha})) {
		$c->stash->{wrong_captcha} = 1;
		return $c->detach;
	}

	if ($c->req->params->{hide_profile}) {
		$c->user->public(0);
	} elsif ($c->req->params->{show_profile}) {
		$c->user->public(1);
	}
	$c->user->update();

	$c->response->redirect($c->chained_uri('My','account'));
	return $c->detach;

}

sub forgotpw_tokencheck :Chained('logged_out') :Args(2) {
	my ( $self, $c, $user, $token ) = @_;
	
	#
	# You can link to here from inside the email: <@ u('My','forgotpw_tokencheck',the_user_object.username,token) @>
	#
	
	#
	# get the user, check if the token stored in him is the token we get
	#

}

sub forgotpw :Chained('logged_out') :Args(0) {
	my ( $self, $c ) = @_;
	return $c->detach if !$c->req->params->{requestpw};
	my $username = $c->req->params->{username};
	my $email = $c->req->params->{emailaddress};
	my $found_user = $c->d->find_user($username);
	my $found_email;
	if ($found_user) {
		$found_email = $found_user->data->{email};
	}
	unless ($found_user && $email eq $found_email) {
		$c->stash->{wrong_user_or_wrong_email} = 1;
		return;
	}
	
	#
	# generate a token, you can use rand() to get a random number and there is Digest::MD5 (already in dist.ini)
	# which gives md5_hex, so you can make the random number look more cool
	# save it on the user (->data->{forgotpw_token} ... ->update())
	#
	
	$c->stash->{email} = {
		to          => $found_user->data->{email},
		from        => 'noreply@xxxxxx.de',
		subject     => 'Reset Password',
		template	=> 'email/forgotpw.tt',
		charset		=> 'utf-8',
		content_type => 'text/plain',
	};

	$c->forward( $c->view('Email::TT') );
	
	$c->stash->{email_sent};
	
}

sub login :Chained('logged_out') :Args(0) {
    my ( $self, $c ) = @_;

	$c->stash->{no_userbox} = 1;
	
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

	my %xmpp = $c->model('DDGC')->xmpp->user($username);

	if (%xmpp) {
		$c->stash->{user_exist} = $username;
		$error = 1;
	} else {
		$c->stash->{username} = $username;
	}

	return $c->detach if $error;

	if (!$c->model('DDGC')->create_user($username,$password)) {
		$c->stash->{register_failed} = 1;
		return $c->detach;
	}

	$c->response->redirect($c->uri_for($self->action_for('login')));

}

__PACKAGE__->meta->make_immutable;

1;
