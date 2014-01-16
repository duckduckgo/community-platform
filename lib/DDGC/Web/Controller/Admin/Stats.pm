package DDGC::Web::Controller::Admin::Stats;
# ABSTRACT: Statistics web controller class

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base :Chained('/admin/base') :PathPart('stats') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->add_bc('Statistics', $c->chained_uri('Admin::Stats','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
}

sub contributions :Chained('base') :Args(0) {
  my ( $self, $c ) = @_;

}

no Moose;
__PACKAGE__->meta->make_immutable;
