package DDGC::Web::Controller::Screen;
use Moose;
use namespace::autoclean;

use DDGC::Config;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('screen') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub view :Chained('base') :PathPart('') :Args(1) {
    my ( $self, $c, $id ) = @_;
	$c->stash->{screen} = $c->model('DB::Screen')->find({
		id => $id,
		deleted => 0,
	});
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	my $page = $c->req->params->{page}+0;
	$page = 1 if $page < 1;
	$c->stash->{screens} = [$c->model('DB::Screen')->search({
		deleted => 0,
	},{
		page => $page,
		rows => 20,
	})->all];
}

sub do :Chained('base') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub upload :Chained('do') :Args(0) {
    my ( $self, $c ) = @_;
}

__PACKAGE__->meta->make_immutable;

1;
