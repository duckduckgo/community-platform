package DDGC::Web::Controller::Admin;
use Moose;
use namespace::autoclean;

use DDGC::Config;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('admin') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	
	if (!$c->user || !$c->user->admin) {
		$c->response->redirect($c->chained_uri('Base','welcome',{ admin_required => 1 }));
		return $c->detach;
	}
	$c->stash->{title} = 'Admin area';
	$c->stash->{headline_template} = 'headline/admin.tt';
}

sub index :Chained('base') :Args(0) {
    my ( $self, $c ) = @_;
}

__PACKAGE__->meta->make_immutable;

1;
