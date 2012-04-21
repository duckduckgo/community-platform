package DDGC::Web::Controller::Blog;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Email::Valid;

sub base :Chained('/base') :PathPart('blog') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->stash->{blog_entries} = $c->d->blog->list_entries;
}

sub view :Chained('base') :PathPart('') :Args(1) {
  my ( $self, $c, $blog_entry_url ) = @_;
  $c->stash->{blog_entry} = $c->d->blog->get_entry($blog_entry_url);
  $c->stash->{headline_template} = 'headline/blog.tt';
}

1;
