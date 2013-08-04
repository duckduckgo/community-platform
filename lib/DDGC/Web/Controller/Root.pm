package DDGC::Web::Controller::Root;
# ABSTRACT: Main web controller class

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub base :Chained('/') :PathPart('') :CaptureArgs(0) {
	my ( $self, $c ) = @_;

	if ( my ( $username, $password ) = $c->req->headers->authorization_basic ) {
		$c->authenticate({ username => $username, password => $password, }, 'users');
	}

	$c->stash->{template_layout} = [ 'base.tx' ];
	$c->stash->{ddgc_config} = $c->d->config;
	$c->stash->{xmpp_userhost} = $c->d->config->prosody_userhost;
	$c->stash->{prefix_title} = 'DuckDuckGo Community';
	$c->stash->{user_counts} = $c->d->user_counts;
	$c->stash->{page_class} = "page-home texture";

	$c->wiz_check;

	$c->add_bc('Home', $c->chained_uri('Root','index'));
}

sub captcha :Chained('base') :Args(0) {
	my ($self, $c) = @_;
	$c->create_captcha();
}

sub country_flag :Chained('base') :Args(2) {
	my ( $self, $c, $size, $country_code ) = @_;
	if ($country_code =~ m/(\w+)\.png$/) {
		$country_code = $1;
	}
	my $country = $c->d->rs('Country')->find({ country_code => $country_code });
	unless ($country) {
		$c->response->status(404);
		return $c->detach;
	}
	$c->serve_static_file($country->flag($size));
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ($self, $c) = @_;
	$c->stash->{no_breadcrumb} = 1;
	$c->stash->{title} = 'Welcome to the DuckDuckGo Community Platform';
}

sub default :Chained('base') :PathPart('') :Args {
	my ( $self, $c ) = @_;
	$c->response->status(404);
	$c->add_bc('Not found', '');
}

sub end : ActionClass('RenderView') {
	my ( $self, $c ) = @_;
	my $template = $c->action.'.tx';
	push @{$c->stash->{template_layout}}, $template;

	$c->session->{last_url} = $c->req->uri;
	if ($c->user) {
		$c->stash->{user_notification_count} = $c->user->event_notifications_undone_count;
		$c->run_after_request(sub { $c->d->envoy->update_own_notifications });
	}

	$c->wiz_post_check;
}

no Moose;
__PACKAGE__->meta->make_immutable;
