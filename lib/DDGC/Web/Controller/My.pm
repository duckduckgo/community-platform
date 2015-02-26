package DDGC::Web::Controller::My;
# ABSTRACT: User related functions web controller class

use Moose;
use namespace::autoclean;

use DDGC::Config;
use Time::HiRes qw/ sleep /;
use Email::Valid;
use Digest::MD5 qw( md5_hex );
use Try::Tiny;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('my') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->stash->{page_class} = "page-account";
}

sub logout :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{not_last_url} = 1;
	try {
		$c->require_action_token;
		$c->logout;
		$c->delete_session;
	};
	$c->response->redirect($c->chained_uri('Root','index'));
	return $c->detach;
}

sub finishwizard :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{not_last_url} = 1;
	$c->wiz_finished;
	delete $c->session->{wizard_finished};
	$c->stash->{x} = { ok => 1 };
	$c->forward( $c->view('JSON') );
	return $c->detach;
}

sub campaign_nothanks :Chained('base') :Args(0) {
	my ( $self, $c, $campaign, $source ) = @_;
	$c->stash->{not_last_url} = 1;

	$c->stash->{x} = ( $c->user->set_seen_campaign(
		$c->stash->{campaign_info}->{campaign_name},
		'campaign',
	) ) ?
	{ ok => 1 } : { ok => 0 };

	if ($c->stash->{x}->{ok}) {
		$c->session->{campaign_notification} = undef;
		$c->stash->{campaign_info} = undef;
	}
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
	$c->stash->{not_last_url} = 1;
	$c->stash->{title} = 'Login';
	$c->add_bc($c->stash->{title}, '');

	$c->stash->{no_userbox} = 1;
	$c->stash->{register_successful} = $c->req->params->{register_successful};

	my $last_url = $c->session->{last_url};

	if ($c->stash->{username} = $c->req->params->{ $c->session->{username_field} }) {

		if ($c->stash->{username} =~ /@/) {
			$c->stash->{username_at} = 1;
			return $c->detach;
		}

		$c->session->{username_field} = $c->d->uid;
		my $user = $c->d->find_user($c->stash->{username});
		if (($user && $user->rate_limit_login)
		    || $c->session->{failed_logins} > $c->d->config->login_failure_session_limit) {
			sleep 0.5; # Look like we tried
			$c->stash->{login_failed} = 1;
			return $c->detach;
		}

		if ( my $username = lc($c->stash->{username}) and
		     my $password = $c->req->params->{password} ) {
			if ($c->authenticate({
				username => $username,
				password => $password,
			}, 'users')) {
				$c->change_session_id;
				my $data = $c->user->data;
				delete $data->{token};
				delete $data->{invalidate_existing_sessions};
				$c->user->data($data);
				$c->user->update;
				$c->set_new_action_token;
				$last_url = $c->chained_uri('My','account') unless defined $last_url;
				$c->response->redirect($last_url);
				return $c->detach;
			} else {
				$c->session->{failed_logins} ++;
				if ($user) {
					$user->failedlogins->create({});
				}
				$c->stash->{login_failed} = 1;
			}
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

sub report :Chained('logged_in') :Args(0) {
	my ( $self, $c ) = @_;
	$c->require_action_token;

	$c->stash->{title} = 'Content Report';
	$c->add_bc($c->stash->{title}, '');
	eval {
		$c->user->add_report(
			$c->req->params->{context},
			$c->req->params->{context_id},
			type => $c->req->params->{type},
			text => $c->req->params->{text},
		);
	};
	if ($@) {
		$c->stash->{x} = { error => $@ };
	} else {
		$c->stash->{x} = { ok => 1 };
	}
	if ($c->req->params->{json}) {
		$c->forward('View::JSON');
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
				$c->require_action_token;
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
			$c->require_action_token;
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
			$c->require_action_token;
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

	return $c->detach unless $c->req->params->{save_email};

	$c->require_action_token;

	if (!$c->user->check_password($c->req->params->{password})) {
		$c->stash->{wrong_password} = 1;
		return;
	}

	my $email = Email::Valid->address($c->req->params->{emailaddress});

	if ($c->req->params->{emailaddress} && !$email ) {
		$c->stash->{no_valid_email} = 1;
		return;
	}

	$c->user->data({}) if !$c->user->data;
	my $data = $c->user->data();
	$data->{email} = $email;
	delete $data->{token};
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

	$c->require_action_token;

	if (!$c->user->check_password($c->req->params->{password})) {
		$c->stash->{wrong_password} = 1;
		return $c->detach;
	}

	if ($c->req->params->{delete_profile}) {
		my $username = $c->user->username;
		my $delete_error = 0;
		try {
			$c->d->delete_user($username);
		}
		catch {
			$delete_error = 1;
		};
		if ($delete_error) {
			$c->stash->{delete_error} = 1;
			return $c->detach;
		}
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

	$c->require_action_token;
	
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

	return unless $user && $user->lowercase_username eq lc($username);
	return unless $user->data;
	unless ($c->stash->{check_token} eq $user->data->{token}) {
		$c->stash->{invalid_token} = 1;
		return $c->detach;
	}
	if ($user->data->{token_timestamp} &&
		time > $user->data->{token_timestamp} + (60 * 60 * 24)) {
		$c->stash->{token_expired} = 1;
		return $c->detach;
	}
	return if !$c->req->params->{forgotpw_tokencheck};
	
	my $error = 0;

	if ($c->req->params->{repeat_password} ne $c->req->params->{password}) {
		$c->stash->{password_different} = 1;
		$error = 1;
	}

	if (!defined $c->req->params->{password} or length($c->req->params->{password}) < 8) {
		$c->stash->{password_too_short} = 1;
		$error = 1;
	}

	return if $error;
	
	my $newpass = $c->req->params->{password};
	my $data = $user->data;
	delete $data->{token};
	$data->{invalidate_existing_sessions} = 1;
	delete $data->{password_reset_session_token};
	$user->data($data);
	$user->update;
	$c->d->update_password($username,$newpass);

	$c->stash->{newpw_username} = $username;

	$c->d->postman->template_mail(
		$user->data->{email},
		'"DuckDuckGo Community" <noreply@dukgo.com>',
		'[DuckDuckGo Community] New password for '.$username,
		'newpw',
		$c->stash,
	);

	$c->stash->{resetok} = 1;
}

sub capitalize :Chained('logged_in') :Args(0) {
	my ( $self, $c ) = @_;

	return unless $c->req->params->{capitalize};

	$c->require_action_token;

	if (lc($c->req->params->{new_username}) ne lc($c->user->username)) {
		$c->stash->{changed_error} = 1;
		my $error_count;
		if (defined $c->req->params->{changed_error_count}) {
			$error_count = $c->req->params->{changed_error_count} + 1;
		} else {
			$error_count = 1;
		}
		$c->stash->{changed_error_count} = $error_count;
		return;
	}

	$c->user->db->username($c->req->params->{new_username});
	$c->user->db->update;

	$c->response->redirect($c->chained_uri('My','account',{ username_changed => 1 }));
	return $c->detach;
}

sub changepw :Chained('logged_in') :Args(0) {
	my ( $self, $c ) = @_;

	$c->stash->{title} = 'Change password';
		$c->add_bc($c->stash->{title}, '');

	return unless $c->req->params->{changepw};
	
	$c->require_action_token;

	my $error = 0;

	if (!$c->user->check_password($c->req->params->{old_password})) {
		$c->stash->{old_password_wrong} = 1;
		$error = 1;
	}

	if ($c->req->params->{repeat_password} ne $c->req->params->{password}) {
		$c->stash->{password_different} = 1;
		$error = 1;
	}

	if (!defined $c->req->params->{password} or length($c->req->params->{password}) < 8) {
		$c->stash->{password_too_short} = 1;
		$error = 1;
	}

	return if $error;
	
	my $newpass = $c->req->params->{password};
	$c->d->update_password($c->user->username,$newpass);
	my $data = $c->user->data;

	if ($data && $data->{email}) {
		$c->stash->{newpw_username} = $c->user->username;
		$c->d->postman->template_mail(
			$c->user->data->{email},
			'"DuckDuckGo Community" <noreply@dukgo.com>',
			'[DuckDuckGo Community] New password for '.$c->user->username,
			'newpw',
			$c->stash,
		);
	}

	delete $data->{token};
	$data->{invalidate_existing_sessions} = 1;
	$data->{password_reset_session_token} = $c->session->{action_token};
	$c->user->data($data);
	$c->user->update;

	$c->stash->{changeok} = 1;
}

sub flair :Chained('logged_in') :Args(0) {
	my ( $self, $c ) = @_;
	$c->require_action_token;

	$c->user->toggle_hide_flair;

	$c->response->redirect($c->chained_uri('My','account'));
	return $c->detach;
}

sub forum_links_same_window :Chained('logged_in') :Args(0) {
	my ( $self, $c ) = @_;
	$c->require_action_token;

	$c->user->toggle_forum_links;

	$c->response->redirect($c->chained_uri('My','account'));
	return $c->detach;
}

sub forgotpw :Chained('logged_out') :Args(0) {
	my ( $self, $c ) = @_;

	$c->stash->{title} = 'Forgot password';
		$c->add_bc($c->stash->{title}, '');

	return $c->detach if !$c->req->params->{requestpw};
	if (++$c->session->{forgotpw_requests} > $c->d->config->forgotpw_session_limit) {
		sleep .5;
		$c->stash->{sentok} = 1;
		return $c->detach;
	}

	$c->stash->{forgotpw_username} = lc($c->req->params->{ $c->session->{username_field} });

	if ($c->stash->{forgotpw_username} =~ /@/) {
		$c->stash->{username_at} = 1;
		return $c->detach;
	}

	$c->session->{username_field} = $c->d->uid;
	
	my $user = $c->d->find_user($c->stash->{forgotpw_username});
	if (!$user || !$user->data || !$user->data->{email}) {
		sleep .5;
		$c->stash->{sentok} = 1;
		return $c->detach;
	}

	if ($user->data->{token_timestamp} &&
	    time < $user->data->{token_timestamp} +
	        $c->d->config->forgotpw_user_time_limit) {
		sleep .5;
		$c->stash->{sentok} = 1;
		return $c->detach;
	}

	my $token = $c->d->uid;
	my $data = $user->data;
	$data->{token} = $token;
	$data->{token_timestamp} = time;
	$user->data($data);
	$user->update;
	$c->stash->{user} = $user->username;

	$c->stash->{forgotpw_link} = $c->chained_uri('My','forgotpw_tokencheck',$user->lowercase_username,$token);

	$c->d->postman->template_mail(
		$user->data->{email},
		'"DuckDuckGo Community" <noreply@dukgo.com>',
		'[DuckDuckGo Community] Reset password for '.$user->username,
		'forgotpw',
		$c->stash,
	);

	$c->stash->{sentok} = 1;
}

sub register :Chained('logged_out') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{not_last_url} = 1;

	$c->stash->{page_class} = "page-signup";

	$c->stash->{title} = 'Create a new account';
	$c->add_bc($c->stash->{title}, '');

	$c->stash->{no_login} = 1;

	if (!$c->req->params->{register}) {
		return $c->detach;
	}

	$c->stash->{username} = $c->req->params->{$c->session->{username_field}};
	$c->stash->{email} = $c->req->params->{email};
	$c->session->{username_field} = $c->d->uid;

	if (!$c->validate_captcha($c->req->params->{captcha})) {
		$c->stash->{wrong_captcha} = 1;
		return $c->detach;
	}

	my $error = 0;

	if ($c->req->params->{repeat_password} ne $c->req->params->{password}) {
		$c->stash->{password_different} = 1;
		$error = 1;
	}

	if (!defined $c->req->params->{password} or length($c->req->params->{password}) < 8) {
		$c->stash->{password_too_short} = 1;
		$error = 1;
	}

	if (!defined $c->stash->{username} or $c->stash->{username} eq '') {
		$c->stash->{need_username} = 1;
		$error = 1;
	}

	my $email = Email::Valid->address($c->req->params->{email});
	if ( $c->req->params->{email} && !$email ) {
		$c->stash->{not_valid_email} = 1;
		$error = 1;
	}

	if ($c->stash->{username} !~ /^[a-zA-Z0-9_\.]+$/) {
		$c->stash->{not_valid_chars} = 1;
		$error = 1;
	}

	return $c->detach if $error;
	
	my $username = $c->stash->{username};
	my $password = $c->req->params->{password};
	
	my $find_user = $c->d->find_user($username);

	if ($find_user) {
		$c->stash->{user_exist} = $username;
		$error = 1;
	}

	return $c->detach if $error;

	# Skip actual account creation if this field is filled
	unless ($c->req->params->{emailagain}) {
		my $user = $c->d->create_user($username,$password);

		if ($user) {
			$user->check_password($password);
			if ($email) {
				$user->data({}) if !$user->data;
				my $data = $user->data();
				$data->{email} = $email;
				$user->data($data);
				$user->update;
			}
			$c->session->{action_token} = undef;
			$c->session->{captcha_string} = undef;
			$c->session->{username_field} = undef;
		} else {
			$c->stash->{register_failed} = 1;
			return $c->detach;
		}
	}

	$c->response->redirect($c->chained_uri('My','login',{ register_successful => 1, username => $username }));

}

sub requestlanguage :Chained('logged_in') :Args(0) {
	my ($self, $c) = @_;
	$c->stash->{not_last_url} = 1;

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

			$c->stash->{c} = $c;
			$c->d->postman->template_mail(
				$c->d->config->feedback_email,
				'"DuckDuckGo Community" <noreply@dukgo.com>',
				'[DDG Language Request] New request',
				'requestlanguage',
				$c->stash,
			);

			$c->stash->{thanks_for_languagerequest} = 1;

		}
	}
}

# Temporary Uservoice claiming point
sub uservoice_claim :Chained('logged_in') :Args(2) {
	my ($self, $c, $claim_ref, $claim ) = @_;

	if ($claim_ref =~ m/(\w)(\d+)/) {
		my $type = $1;
		my $id = $2;
		my $obj;
		if ($type eq 'i') {
			$obj = $c->d->rs('Idea')->find($id);
		} else {
			$obj = $c->d->rs('Comment')->find($id);			
		}
		if ($obj) {
			if ($obj->data->{uservoice_claim} eq $claim) {
				my $email = $obj->data->{uservoice_email};
				my @ideas = $c->d->rs('Idea')->search({
				  data => { -like => '%uservoice_claim%' },
				})->all;
				my %claims;
				for my $idea (@ideas) {
					if (defined $idea->data->{uservoice_email} && $idea->data->{uservoice_email} eq $email) {
						$idea->users_id($c->user->id);
						delete $idea->data->{uservoice_email};
						delete $idea->data->{uservoice_claim};
						delete $idea->data->{uservoice_user};
						delete $idea->data->{import};
						delete $idea->data->{import_user};
						$idea->data($idea->data);
						$idea->update;
						my $url = $c->chained_uri(@{$idea->u});
						$claims{$url} = $idea unless defined $claims{$url};
					}
				}
				my @comments = $c->d->rs('Comment')->search({
				  data => { -like => '%uservoice_claim%' },
				})->all;
				for my $comment (@comments) {
					if (defined $comment->data->{uservoice_email} && $comment->data->{uservoice_email} eq $email) {
						$comment->users_id($c->user->id);
						delete $comment->data->{uservoice_email};
						delete $comment->data->{uservoice_claim};
						delete $comment->data->{uservoice_user};
						delete $comment->data->{import};
						delete $comment->data->{import_user};
						$comment->data($comment->data);
						$comment->update;
						my $url = $c->chained_uri(@{$comment->u});
						$claims{$url} = $comment unless defined $claims{$url};
					}
				}
				$c->stash->{claims} = [values %claims];
			}
		}
	}

}

no Moose;
__PACKAGE__->meta->make_immutable;
