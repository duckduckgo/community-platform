package DDGC::Web::Controller::Help;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('help') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	$c->stash->{title} = 'Help';
	$c->stash->{headline_template} = 'headline/help.tt';
	$c->add_bc('Help', $c->chained_uri('Help','base'));
}

sub help :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $key ) = @_;
	$c->stash->{help} = $c->model('DB::Help')->search({ key => $key })->first;
	if (!$c->stash->{help}) {
		$c->response->redirect($c->chained_uri('Help','list'));
		return $c->detach;
	}
	$c->add_bc($key, $c->chained_uri('Help','view',$key));
}

sub view :Chained('help') :Args(0) {
    my ( $self, $c ) = @_;
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

no Moose;
__PACKAGE__->meta->make_immutable;
