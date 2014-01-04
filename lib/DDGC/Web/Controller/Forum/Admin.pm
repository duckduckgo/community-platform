package DDGC::Web::Controller::Forum::Admin;
# ABSTRACT: Forum admin functions

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

sub base : Chained('/forum/base') PathPart('admin') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  if (!$c->user) {
    $c->response->redirect($c->chained_uri('My','login'));
    return $c->detach;
  }
  if (!$c->user->is('forum_manager')) {
    $c->response->redirect($c->chained_uri('Root','index',{
      access_denied => 1,
    }));
    return $c->detach;
  }
}

sub moderations : Chained('base') Args(0) {
  my ( $self, $c ) = @_;

  $c->stash->{moderations} = [sort {
    $a->created <=> $b->created
  } map {
    ($c->d->rs($_)->search({
      ghosted => 1,
      checked => undef,
    })->all)
  } qw( Idea Thread Comment )];
}

sub reports : Chained('base') Args(0) {
  my ( $self, $c ) = @_;

  $c->stash->{reports} = [sort {
    $a->created <=> $b->created
  } map {
    ($c->d->rs($_)->search({
      reported => { '!=' => '[]' },
    })->all)
  } qw( Idea Thread Comment )];
}

no Moose;
__PACKAGE__->meta->make_immutable;
