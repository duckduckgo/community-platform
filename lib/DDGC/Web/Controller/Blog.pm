package DDGC::Web::Controller::Blog;
# ABSTRACT: Legacy blog controller shim to allow chained_uri to work.

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('blog') :CaptureArgs(0) {}

sub post_base :Chained('base') :PathPart('post') :CaptureArgs(0) {}

sub post :Chained('post_base') :PathPart('') :Args(0) {}

1;
