package DDGC::Web::Controller::Blog;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Email::Valid;

sub base :Chained('/base') :PathPart('blog') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
}

sub do :Chained('base') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
}

sub index :Chained('do') :PathPart('index') :Args(0) {
  my ( $self, $c ) = @_;
  $c->stash->{entries} = $c->d->blog->list_entries;
}

sub topic :Chained('base') :Args(1) {
  my ( $self, $c, $topic ) = @_;
  $c->stash->{entries} = $c->d->blog->get_topical_entries($topic);
  return $c->go('/default') unless $c->stash->{entries};
}

sub view :Chained('base') :PathPart('') :Args(1) {
  my ( $self, $c, $blog_entry_url ) = @_;
  $c->stash->{url} = $blog_entry_url;
  $c->stash->{entry} = $c->d->blog->list_entry($blog_entry_url);
}

1;
