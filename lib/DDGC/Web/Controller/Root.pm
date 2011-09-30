package DDGC::Web::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

use DDGC::Config;

__PACKAGE__->config(namespace => '');

sub base :Chained('/') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	$c->stash->{template_layout} = [ 'base.tt' ];
	$c->stash->{u} = sub { $c->chained_uri(@_) };
	$c->stash->{l} = sub { $c->localize(@_) };
	$c->stash->{xmpp_userhost} = DDGC::Config::prosody_userhost;
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	if ($c->user) {
		return $c->detach('My','timeline');
	} else {
		$c->response->redirect($c->chained_uri('Base','welcome'));
		return $c->detach;
	}
}

sub default :Chained('base') :PathPart('') :Args {
    my ( $self, $c ) = @_;
	push @{$c->stash->{template_layout}}, 'centered_content.tt';
    $c->response->status(404);
}

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;
	my $template = $c->action.".tt";
	push @{$c->stash->{template_layout}}, $template;
}

__PACKAGE__->meta->make_immutable;

1;
