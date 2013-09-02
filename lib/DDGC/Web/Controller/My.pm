package DDGC::Web::Controller::My;
# ABSTRACT: User related functions web controller class

use Moose;
use namespace::autoclean;

use DDGC::Config;
use DDGC::User;
use Email::Valid;
use Digest::MD5 qw( md5_hex );

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('my') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	$c->stash->{page_class} = "page-account";
}

sub logout :Chained('base') :Args(0) {
    my ( $self, $c ) = @_;
	$c->logout;
	$c->delete_session;
	$c->response->redirect($c->chained_uri('Root','index'));
	return $c->detach;
}

sub finishwizard :Chained('base') :Args(0) {
    my ( $self, $c ) = @_;
	$c->wiz_finished;
	delete $c->session->{wizard_finished};
	$c->stash->{x} = { ok => 1 };
	$c->forward( $c->view('JSON') );
	return $c->detach;
}

sub logged_out :Chained('base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if ($c->user) {
		$c->response->redirect($c->chained_uri('My','account'));
		return $c->detach;
	}
}

sub login :Chained('logged_out') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{title} = 'Login';
	$c->add_bc($c->stash->{title}, '');

	$c->stash->{no_userbox} = 1;
	$c->stash->{register_successful} = $c->req->params->{register_successful};

	my $last_url = $c->session->{last_url};
	my $login_url = $c->chained_uri('My','login');
	my $register_url = $c->chained_uri('My','register');
	my $captcha_url = $c->chained_uri('Root','captcha');

	if ($last_url !~ /^$login_url/ && $last_url !~ /^$register_url/ &&
		$last_url !~ /^$captcha_url/) {
		$c->session->{login_from} = $last_url;
	}

	if ($c->req->params->{username}) {

		if ($c->req->params->{username} !~ /^[a-zA-Z0-9_\.]+$/) {
			$c->stash->{not_valid_username} = 1;
		} else {
			if ( my $username = lc($c->req->params->{username}) and my $password = $c->req->params->{password} ) {
				if ($c->authenticate({
					username => $username,
					password => $password,
				}, 'users')) {
					my $new_url;
					$new_url = delete $c->session->{login_from} if (defined $c->session->{login_from});
					$new_url = $c->chained_uri('My','account') unless defined $new_url;
					$c->response->redirect($new_url);
					return $c->detach;
				} else {
					$c->stash->{login_failed} = 1;
				}
			}
			$c->stash->{username} = $c->req->params->{username};
		}

	}
}

sub logged_in :Chained('base') :PathPart('') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->stash->{title} = 'My Account';
	$c->add_bc($c->stash->{title}, $c->chained_uri('My','account'));
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
}

sub account :Chained('logged_in') :Args(0) {
    my ( $self, $c ) = @_;

	$c->bc_index;

	$c->stash->{no_languages} = $c->req->params->{no_languages}
		unless defined $c->stash->{no_languages};

    my $saved = 0;

    for (keys %{$c->req->params}) {

    	if ($_ =~ m/^update_language_(\d+)/) {
    		my $grade = $c->req->param('language_grade_'.$1);
    		if ($grade) {
	    		my ( $user_language ) = $c->user->db->user_languages->search({ language_id => $1 })->all;
	    		if ($user_language) {
	    			$user_language->grade($grade);
	    			$user_language->update;
					$saved = 1;
	    		}
    		}
    	}

		if ($_ eq 'add_language') {
			my $language_id = $c->req->params->{language_id};
			my $grade = $c->req->params->{language_grade};
			if ($grade and $language_id) {
				$c->user->db->update_or_create_related('user_languages',{
					grade => $grade,
					language_id => $language_id,
				},{
					key => 'user_language_language_id_username',
				});
				$saved = 1;
			}
		}

		if ($_ eq 'remove_language') {
			my $language_id = $c->req->params->{$_};
			$c->user->db->user_languages->search({ language_id => $language_id })->delete;
			$saved = 1;
		}

    }

    $c->stash->{saved} = $saved;

	$c->stash->{user_has_languages} = $c->user ? $c->user->user_languages->count : 0;

	$c->stash->{languages} = [$c->d->rs('Language')->search({},{
		order_by => { -asc => 'locale' },
	})->all];
}

sub email :Chained('logged_in') :Args(0) {
	my ( $self, $c, ) = @_;

	$c->stash->{title} = 'Email';
	$c->add_bc($c->stash->{title}, '');

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

sub delete :Chained('logged_in') :Args(0) {
    my ( $self, $c ) = @_;

	$c->stash->{title} = 'Delete your account';
	$c->add_bc($c->stash->{title}, '');

	return $c->detach unless $c->req->params->{delete_profile};
	
	if (!$c->validate_captcha($c->req->params->{captcha})) {
		$c->stash->{wrong_captcha} = 1;
		return $c->detach;
	}

	if ($c->req->params->{delete_profile}) {
		my $username = $c->user->username;
		$c->d->delete_user($username);
		$c->logout;
		$c->response->redirect($c->chained_uri('Root','index'));
		return $c->detach;
	}
}

sub public :Chained('logged_in') :Args(0) {
    my ( $self, $c ) = @_;

    if ($c->user->public) {
    	$c->stash->{title} = 'Make account private';
	    $c->add_bc($c->stash->{title}, '');
    } else {
    	$c->stash->{title} = 'Make account public';
	    $c->add_bc($c->stash->{title}, '');
    }

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

	$c->stash->{title} = 'Forgot password token check';
    $c->add_bc($c->stash->{title}, '');

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
		template        => 'email/newpw.tx',
		charset         => 'utf-8',
		content_type => 'text/plain',
	};

	$c->forward( $c->view('Email::Xslate') );

	$c->stash->{resetok} = 1;
}

sub changepw :Chained('logged_in') :Args(0) {
	my ( $self, $c ) = @_;

	$c->stash->{title} = 'Change password';
    $c->add_bc($c->stash->{title}, '');

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
			template        => 'email/newpw.tx',
			charset         => 'utf-8',
			content_type => 'text/plain',
		};

		$c->forward( $c->view('Email::Xslate') );
	}

	$c->stash->{changeok} = 1;
}

sub forgotpw :Chained('logged_out') :Args(0) {
	my ( $self, $c ) = @_;

	$c->stash->{title} = 'Forgot password';
    $c->add_bc($c->stash->{title}, '');

	return $c->detach if !$c->req->params->{requestpw};
	$c->stash->{forgotpw_username} = lc($c->req->params->{username});
	$c->stash->{forgotpw_email} = $c->req->params->{email};
	my $user = $c->d->find_user($c->stash->{forgotpw_username});
	if (!$user || !$user->data || !$user->data->{email} || $c->stash->{forgotpw_email} ne $user->data->{email}) {
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
		template	=> 'email/forgotpw.tx',
		charset		=> 'utf-8',
		content_type => 'text/plain',
	};

	$c->forward( $c->view('Email::Xslate') );
	
	$c->stash->{sentok} = 1;
}

sub register :Chained('logged_out') :Args(0) {
    my ( $self, $c ) = @_;

	$c->stash->{page_class} = "page-signup";

	$c->stash->{title} = 'Create a new account';
    $c->add_bc($c->stash->{title}, '');

	$c->stash->{no_login} = 1;

	return $c->detach if !$c->req->params->{register};

	$c->stash->{username} = $c->req->params->{username};
	$c->stash->{email} = $c->req->params->{email};

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

	if ( $c->req->params->{email} && !Email::Valid->address($c->req->params->{email}) ) {
		$c->stash->{not_valid_email} = 1;
		$error = 1;
	}

	if ($c->req->params->{username} !~ /^[a-zA-Z0-9_\.]+$/) {
		$c->stash->{not_valid_chars} = 1;
		$error = 1;
	}

	return $c->detach if $error;
	
	my $username = lc($c->req->params->{username});
	my $password = $c->req->params->{password};
	my $email = $c->req->params->{email};
	
	my %xmpp = $c->model('DDGC')->xmpp->user($username);

	if (%xmpp) {
		$c->stash->{user_exist} = $username;
		$error = 1;
	}

	return $c->detach if $error;

	my $user = $c->model('DDGC')->create_user($username,$password);

	if ($user) {
		if ($email) {
			$user->data({}) if !$user->data;
			my $data = $user->data();
			$data->{email} = $email;
			$user->data($data);
			$user->update;
		}
	} else {
		$c->stash->{register_failed} = 1;
		return $c->detach;
	}

	$c->response->redirect($c->chained_uri('My','login',{ register_successful => 1, username => $username }));

}

sub requestlanguage :Chained('logged_in') :Args(0) {
	my ($self, $c) = @_;

	$c->stash->{title} = 'Request language';
    $c->add_bc($c->stash->{title}, '');
	
	if ($c->req->params->{submit}) {

		my $error = 0;
	
		if ( !$c->req->params->{email} or !Email::Valid->address($c->req->params->{email}) ) {
			$c->stash->{no_valid_email} = 1;
			$error = 1;
		}

		if ( !$c->req->params->{lang_in_local} ) {
			$c->stash->{required_lang_in_local} = 1;
			$error = 1;
		}

		if ( !$c->req->params->{name_in_english} ) {
			$c->stash->{required_name_in_english} = 1;
			$error = 1;
		}

		if ( !$c->req->params->{name_in_local} ) {
			$c->stash->{required_name_in_local} = 1;
			$error = 1;
		}
		
		if ($error) {

			$c->stash->{requestlanguage_email} = $c->req->params->{email};
			$c->stash->{requestlanguage_lang_in_local} = $c->req->params->{lang_in_local};
			$c->stash->{requestlanguage_name_in_english} = $c->req->params->{name_in_english};
			$c->stash->{requestlanguage_name_in_local} = $c->req->params->{name_in_local};
			$c->stash->{requestlanguage_locale} = $c->req->params->{requestlanguage_locale};
			$c->stash->{requestlanguage_flagurl} = $c->req->params->{flagurl};

		} else {

			$c->stash->{email} = {
				to          => 'help@duckduckgo.com',
				from        => 'noreply@dukgo.com',
				header		=> [
					"Reply-To" =>  $c->req->params->{email},
				],
				subject     => '[DuckDuckGo Community] New request for language by ',
				template	=> 'email/requestlanguage.tx',
				charset		=> 'utf-8',
				content_type => 'text/plain',
			};

			$c->stash->{thanks_for_languagerequest} = 1;
			$c->forward( $c->view('Email::Xslate') );

		}
	}
}


# Temporary Zoho import verification stuff
sub zoho_user :Chained('logged_in') :Args(0) {
    my ($self, $c) = @_;

    $c->stash->{title} = "Zoho Username";
    $c->add_bc($c->stash->{title}, '');

    if (defined $c->user->data->{unapproved_zoho_username}) {
        $c->stash->{success} = 1;
        return $c->detach;
    }

    if (defined $c->req->params->{u} && $c->req->params->{u}) {
	$c->user->data({}) if !$c->user->data;
	my $data = $c->user->data;
	$data->{unapproved_zoho_username} = $c->req->params->{u};
	$c->user->data($data);
	$c->user->update;
        $c->stash->{success} = 1;
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;
