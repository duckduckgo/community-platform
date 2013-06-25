package DDGC::Web::Controller::My::Blog;
# ABSTRACT: Userpage editor

use Moose;
BEGIN {extends 'Catalyst::Controller'; }

use DateTime;
use namespace::autoclean;

sub base :Chained('/my/logged_in') :PathPart('blog') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Blog Editor', $c->chained_uri('My::Blog','index'));
	$c->stash->{blog} = $c->user->blog;
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;
}

sub json :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{x} = $c->stash->{blog}->export;
	$c->forward('View::JSON');
}


__PACKAGE__->meta->make_immutable;

1;
