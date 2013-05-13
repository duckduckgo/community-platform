package DDGC::Web::Controller::Root;
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

    #$c->add_bc('Home', $c->chained_uri('Root','index'));
}

sub captcha :Chained('base') :Args(0) {
	my ($self, $c) = @_;
	$c->create_captcha();
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ($self, $c) = @_;
	$c->stash->{title} = 'Welcome';
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
}

__PACKAGE__->meta->make_immutable;

1;
