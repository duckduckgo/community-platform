package DDGC::Web::Controller::My;
use Moose;
use namespace::autoclean;

use DDGC::Config;
use DDGC::User;
use Email::Valid;
use Digest::MD5 qw(md5_base64 md5_hex);
use Gravatar::URL;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('my') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
#	$c->stash->{headline_template} = 'headline/my.tt';
}

sub logout :Chained('base') :Args(0) {
    my ( $self, $c ) = @_;
	$c->logout;
	$c->response->redirect($c->chained_uri('Base','welcome'));
}

sub logged_in :Chained('base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
	push @{$c->stash->{template_layout}}, 'my/base.tt';
}

sub logged_out :Chained('base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if ($c->user) {
		$c->response->redirect($c->chained_uri('My','account'));
		return $c->detach;
	}
}

sub account :Chained('logged_in') :Args(0) {
    my ( $self, $c ) = @_;
	if (!$c->user->db->user_languages->search({})->all) {
		$c->response->redirect($c->chained_uri('My','languages'));
		return $c->detach;
	}
	if ( $c->req->params->{unset_gravatar_email} ) {
		my $data = $c->user->data || {};
		delete $data->{gravatar_email};
		delete $data->{gravatar_url};
		$c->user->data($data);
		$c->user->update;
	}
	if ($c->req->params->{set_gravatar_email}) {
		if ( Email::Valid->address($c->req->params->{gravatar_email}) ) {
			my $data = $c->user->data || {};
			$data->{gravatar_email} = $c->req->params->{gravatar_email};
			$data->{gravatar_url} = gravatar_url(
				email => $data->{gravatar_email},
				rating => "g",
				size => 48,
			);
			$c->user->data($data);
			$c->user->update;
		} else {
			$c->stash->{no_valid_gravatar_email} = 1;
		}
	}
}

sub languages :Chained('logged_in') :Args(0) {
    my ( $self, $c ) = @_;
	$c->stash->{languages} = [$c->model('DB::Language')->search({})->all];
	my $change = 0;
	if ($c->req->params->{remove_user_language}) {
		$change = 1;
		for ($c->user->db->user_languages->search({})->all) {
			if ($_->language->locale eq $c->req->params->{remove_user_language}) {
				$_->delete;
			}
		}
	} elsif ($c->req->params->{language_id} && $c->req->params->{add_user_language}) {
		$change = 1;
		$c->user->db->update_or_create_related('user_languages',{
			grade => $c->req->params->{grade},
			language_id => $c->req->params->{language_id},
		},{
			key => 'user_language_language_id_username',
		});
	}
	delete $c->session->{cur_locale} if $change;
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
	my $data = $c->user->data();
	$data->{email} = $email;
	$c->user->data($data);
	$c->user->update;

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
	my ( $self, $c, $username, $token ) = @_;

	$c->stash->{check_username} = $username;
	$c->stash->{check_token} = $token;

	my $user = $c->d->find_user($username);

	return unless $user && $user->username eq $username;
	return if !$c->req->params->{forgotpw_tokencheck};
	
	my $error = 0;

	if ($c->req->params->{repeat_password} ne $c->req->params->{password}) {
		$c->stash->{password_different} = 1;
		$error = 1;
	}

	if (!defined $c->req->params->{password} or length($c->req->params->{password}) < 3) {
		$c->stash->{password_too_short} = 1;
		$error = 1;
	}

	return if $error;
	
	my $newpass = $c->req->params->{password};
	$c->d->update_password($username,$newpass);

	$c->stash->{email} = {
		to          => $user->data->{email},
		from        => 'noreply@dukgo.com',
		subject     => '[DuckDuckGo Community] New password for '.$username,
		template        => 'email/newpw.tt',
		charset         => 'utf-8',
		content_type => 'text/plain',
	};

	$c->forward( $c->view('Email::TT') );

	$c->stash->{resetok} = 1;
}

sub changepw :Chained('logged_in') :Args(0) {
	my ( $self, $c ) = @_;

	return if !$c->req->params->{changepw};
	
	my $error = 0;

	if (!$c->user->check_password($c->req->params->{old_password})) {
		$c->stash->{old_password_wrong} = 1;
		$error = 1;
	}

	if ($c->req->params->{repeat_password} ne $c->req->params->{password}) {
		$c->stash->{password_different} = 1;
		$error = 1;
	}

	if (!defined $c->req->params->{password} or length($c->req->params->{password}) < 3) {
		$c->stash->{password_too_short} = 1;
		$error = 1;
	}

	return if $error;
	
	my $newpass = $c->req->params->{password};
	$c->d->update_password($c->user->username,$newpass);

	if ($c->user->data && $c->user->data->{email}) {
		$c->stash->{email} = {
			to          => $c->user->data->{email},
			from        => 'noreply@dukgo.com',
			subject     => '[DuckDuckGo Community] New password for '.$c->user->username,
			template        => 'email/newpw.tt',
			charset         => 'utf-8',
			content_type => 'text/plain',
		};

		$c->forward( $c->view('Email::TT') );
	}

	$c->stash->{changeok} = 1;
}

sub forgotpw :Chained('logged_out') :Args(0) {
	my ( $self, $c ) = @_;
	return $c->detach if !$c->req->params->{requestpw};
	$c->stash->{forgotpw_username} = $c->req->params->{username};
	$c->stash->{forgotpw_email} = $c->req->params->{email};
	my $user = $c->d->find_user($c->stash->{forgotpw_username});
	if (!$user || $c->stash->{forgotpw_email} ne $user->data->{email}) {
		$c->stash->{wrong_user_or_wrong_email} = 1;
		return;
	}
	
	my $token = md5_hex(int(rand(99999999)));
	$user->data->{token} = $token;
	$user->update;
	$c->stash->{token} = $token;
	$c->stash->{user} = $user->username;
	
	$c->stash->{email} = {
		to          => $user->data->{email},
		from        => 'noreply@dukgo.com',
		subject     => '[DuckDuckGo Community] Reset password for '.$user->username,
		template	=> 'email/forgotpw.tt',
		charset		=> 'utf-8',
		content_type => 'text/plain',
	};

	$c->forward( $c->view('Email::TT') );
	
	$c->stash->{sentok} = 1;
}

sub login :Chained('logged_out') :Args(0) {
    my ( $self, $c ) = @_;

	$c->stash->{no_userbox} = 1;
	
	if ( my $username = $c->req->params->{username} and my $password = $c->req->params->{password} ) {
		if ($c->authenticate({
			username => $username,
			password => $password,
		}, 'users')) {
			$c->response->redirect($c->chained_uri('My','account'));
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

	$c->response->redirect($c->chained_uri('My','login',{ register_successful => 1 }));

}

__PACKAGE__->meta->make_immutable;

1;
