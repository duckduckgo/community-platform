package DDGC::Web::Controller::My::Help;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/my/base') :PathPart('help') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub xmpp :Chained('base') :Args(0) {}
sub translate :Chained('base') :Args(0) {}
sub screen :Chained('base') :Args(0) {}

__PACKAGE__->meta->make_immutable;

1;
