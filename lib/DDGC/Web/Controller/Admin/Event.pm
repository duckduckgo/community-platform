package DDGC::Web::Controller::Admin::Event;
# ABSTRACT: Administrative view to the event log web controller class

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base :Chained('/admin/base') :PathPart('event') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Event log', $c->chained_uri('Admin::Event','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->bc_index;
}

no Moose;
__PACKAGE__->meta->make_immutable;
