package DDGC::Web::Controller::Admin::Help;
use Moose;
use namespace::autoclean;

use DDGC::Config;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/admin/base') :PathPart('help') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	$c->stash->{helps} = [$c->model('DB::Language')->search({})->all];
}

__PACKAGE__->meta->make_immutable;

1;
