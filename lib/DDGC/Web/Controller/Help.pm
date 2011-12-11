package DDGC::Web::Controller::Help;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('help') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	$c->stash->{title} = 'Help';
	$c->stash->{headline_template} = 'headline/help.tt';
}

sub view :Chained('base') :PathPart('') :Args(1) {
    my ( $self, $c, $key ) = @_;
	$c->stash->{help} = $c->model('DB::Help')->search({ key => $key })->first;
	if (!$c->stash->{help}) {
		$c->response->redirect($c->chained_uri('Help','list'));
		return $c->detach;
	}
}

sub do :Chained('base') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub list :Chained('do') :Args(0) {
    my ( $self, $c ) = @_;
	$c->pager_init($c->action,20);
	$c->stash->{helps} = [$c->model('DB::Help')->search({},{
		page => $c->stash->{page},
		rows => $c->stash->{pagesize},
	})->all];
}

__PACKAGE__->meta->make_immutable;

1;
