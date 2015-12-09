package DDGC::Web::Controller::Root;
# ABSTRACT: Main web controller class

use Moose;
use Path::Class;
use DateTime;
use DateTime::Duration;
use DateTime::Format::Mail;
use URI;
use HTTP::Request::Common;
use JSON::MaybeXS;

use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub base :Chained('/') :PathPart('') :CaptureArgs(0) {
	my ( $self, $c ) = @_;

	if ( my ( $username, $password ) = $c->req->headers->authorization_basic ) {
		unless ($c->authenticate({ username => $username, password => $password, }, 'users')) {
			$c->response->status(401);
			$c->response->body("HTTP auth failed: Unauthorized");
			return $c->detach;
		}
	}

	if ($c->user) {
		$c->d->current_user($c->user);

		if (
			$c->user->data &&
			$c->user->data->{invalidate_existing_sessions} &&
			time < $c->user->data->{invalidate_existing_sessions_timestamp} + (60 * 60 * 24) &&
			( !$c->user->data->{post_invalidation_tokens} ||
			  !grep { $_ eq $c->session->{action_token} } @{ $c->user->data->{post_invalidation_tokens} } )
		) {
			$c->stash->{not_last_url} = 1;
			$c->logout;
			$c->delete_session;
			$c->response->redirect($c->chained_uri('Root','index'));
			return $c->detach;
		}

		if (!$c->session->{campaign_notification_checked}) {
			$c->session->{campaign_notification_checked} = 1;
			my $campaign = $c->user->get_first_available_campaign;
			if ($campaign) {
				if (!$c->user->seen_campaign_notice($campaign, 'campaign')) {
					$c->session->{campaign_notification} = $campaign;
				}
			}
		}

		if ($c->session->{campaign_notification}) {
			my $campaign_config = $c->d->config->campaigns->{$c->session->{campaign_notification}};
			if ($campaign_config->{notification_active}) {
				$c->stash->{campaign_info}->{campaign_id} = $campaign_config->{id};
				$c->stash->{campaign_info}->{campaign_name} = $c->session->{campaign_notification};
				$c->stash->{campaign_info}->{link} = $campaign_config->{url};
				$c->stash->{campaign_info}->{notification} = $campaign_config->{notification};
			}
		}
	}
	elsif (!$c->session->{username_field}) {
		$c->session->{username_field} = $c->d->uid;
	}

	$c->stash->{web_base} = $c->d->config->web_base;
	$c->stash->{template_layout} = [ 'base.tx' ];
	$c->stash->{ddgc_config} = $c->d->config;
	$c->stash->{xmpp_userhost} = $c->d->config->prosody_userhost;
	$c->stash->{prefix_title} = 'DuckDuckGo Community';
	$c->stash->{page_class} = "texture";
	$c->stash->{is_live} = $c->d->is_live;
	$c->stash->{is_view} = $c->d->is_view;
	$c->stash->{is_dev} = ( $c->d->is_live || $c->d->is_view ) ? 1 : 0;
	$c->stash->{errors} = [];
    $c->stash->{js_version} = $c->d->config->js_version;

	$c->set_new_action_token unless defined $c->session->{action_token};
	$c->check_action_token;
	$c->wiz_check;

	$c->stash->{action_token} = $c->session->{action_token};

	$c->add_bc('Home', $c->chained_uri('Root','index'));
}

sub captcha :Chained('base') :Args(0) {
	my ($self, $c) = @_;
	$c->stash->{not_last_url} = 1;
	$c->create_captcha();
}

sub editortest :Chained('base') :Args(0) {}

sub redirect_duckco :Chained('base') :PathPart('topic') :Args(1) {
	my ( $self, $c, $topic ) = @_;
	my $old_url = 'http://duck.co/topic/'.$topic;
	$c->stash->{thread} = $c->d->rs('Thread')->find({
		old_url => $old_url,
	});
	if ($c->stash->{thread}) {
		$c->response->redirect($c->chained_uri(@{$c->stash->{thread}->u}));
		$c->response->status(301);
	} else {
		$c->response->redirect($c->chained_uri('Forum','general',{ thread_notfound => 1 }));
	}
	return $c->detach;
}

sub redir :Chained('base') :PathPart('redir') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{not_last_url} = 1;
	my $u = URI->new( $c->req->param('u') );
	if ( $u->scheme !~ /^http/i ) {
		$c->response->redirect($c->chained_uri('Root','index',{ bad_url => 1 }));
		return $c->detach;
	}
	$c->session->{r_url} = $u->canonical;
	$c->session->{r_referer_validated} = (index($c->req->headers->referer, $c->req->base->as_string) == 0) ? 1 : 0;
	$c->response->redirect($c->chained_uri('Root','r'));
	return $c->detach;
}

sub r :Chained('base') :PathPart('r') :Args(0) {
	my ( $self, $c ) = @_;
	if (!$c->session->{r_url}) {
		$c->response->redirect($c->chained_uri('Root','index'));
		return $c->detach;
	}
	$c->stash->{not_last_url} = 1;
	$c->stash->{template_layout} = ();
	$c->stash->{r_url} = $c->session->{r_url};
	$c->stash->{r_referer_validated} = $c->session->{r_referer_validated};
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ($self, $c) = @_;
	$c->stash->{not_last_url} = 1;
	$c->stash->{no_breadcrumb} = 1;
	$c->stash->{title} = 'Welcome to the DuckDuckGo Community Platform';
	$c->stash->{page_class} = "page-home texture";
}

sub default :Chained('base') :PathPart('') :Args {
	my ( $self, $c ) = @_;
	$c->stash->{not_last_url} = 1;
	$c->response->status(404);
	$c->add_bc('Not found', '');
}

sub end : ActionClass('RenderView') {
	my ( $self, $c ) = @_;
	my $template = $c->action.'.tx';
	push @{$c->stash->{template_layout}}, $template;

	$c->session->{last_url} = $c->req->uri unless $c->stash->{not_last_url};

	if ($c->user) {
		$c->run_after_request(sub {
			$c->d->reset_current_user;
			$c->d->envoy->update_own_notifications;
		});
	}

	$c->wiz_post_check;
}

sub wear :Chained('base') :PathPart('wear') :Args(0) {
	my ( $self, $c ) = @_;

	$c->session->{wear_referer} = lc( $c->req->headers->referer ) if !$c->session->{wear_referer};

	$c->stash->{no_breadcrumb} = 1;

	$c->stash->{share_page} = 1;
	$c->session->{last_url} = $c->req->uri;
	$c->stash->{title} = "DuckDuckGo : Share it & Wear it!";
	$c->session->{campaign_notification} = undef;
	$c->stash->{campaign_info} = undef;
	$c->stash->{share_date} = (DateTime->now + DateTime::Duration->new( days => 30 ))->strftime("%b %e");
	$c->stash->{action_token} = $c->session->{action_token};

	if ($c->user) {
		$c->stash->{user} = $c->user;
		$c->stash->{campaign} = $c->user->get_first_available_campaign;
		if ($c->stash->{campaign}) {
			if ($c->stash->{campaign} eq 'share' && !$c->user->responded_campaign('share')) {
				goto REDIRECT;
			}
			$c->stash->{campaign_config} = $c->d->config->campaigns->{ $c->stash->{campaign} };
			$c->user->set_seen_campaign($c->stash->{campaign}, 'campaign');
		}
		else {
			my $coupon = $c->user->get_coupon('share_followup');
			if ($coupon) {
				$c->stash->{coupon_code} = $coupon;
			}
			else {
				$c->stash->{no_campaign} = 1;
			}
		}
		return $c->detach;
	}

REDIRECT:
	$c->response->redirect( 'https://duckduckgo.com/about' );
	return $c->detach;
}

sub status :Chained('base') :PathPart('status') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Community Platform Status');
	my $dt_now = DateTime->now;
	#$dt_now->formatter( DateTime::Format::Mail->new );
	$c->stash->{title}   = "Community Platform Status",
	$c->stash->{dt_utc}  = DateTime::Format::Mail->format_datetime( $dt_now );
	$c->stash->{version} = $DDGC::VERSION;
	$c->stash->{db}      = eval { $c->d->rs('User')->one_row; };
	$c->stash->{prosody} = eval { $c->d->xmpp->mod_data_access->get('ddgc') };
}

sub slack_usercount :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	my $slack_usercount = $c->d->cache->get('slack_usercount') if defined $c->d->cache->get('slack_usercount');
	if ( !$slack_usercount ) {
		my $response = $c->d->http->request(
			GET sprintf( 'https://slack.com/api/users.list?token=%s', $c->d->config->slack_key )
		);
		if ( $response->is_success ) {
			my $users = JSON::MaybeXS->new->utf8(1)->decode($response->content);
			if ( $users->{ok} ) {
				$slack_usercount = scalar @{ $users->{members} };
				$c->d->cache->set( 'slack_usercount', $slack_usercount, '15 minutes' );
			}
		}
		$slack_usercount = 0 if !$slack_usercount;
	}
	$c->stash->{x} = {
		slack_usercount => $slack_usercount,
		ok => !!$slack_usercount,
	};
	$c->forward('View::JSON');
}

sub error :Chained('base') :PathPart('error') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{error_msg} = $c->session->{error_msg};
	delete $c->session->{error_msg};
	if (!$c->stash->{error_msg}) {
		$c->response->redirect($c->chained_uri('Root','index'));
		return $c->detach;
	}
	$c->stash->{template_layout} = ();
}

no Moose;
__PACKAGE__->meta->make_immutable;

