package DDGC::Web::Controller::Idea;
# ABSTRACT: Idea controller

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('idea') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $self->add_bc('Instant Answer Ideas',$c->chained_uri('Forum::Idea','index'));
  $c->stash->{ideas} = $c->d->rs('Idea')->search_rs({},{
    order_by => { -desc => 'me.created' },
  });
}

sub index :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
}

sub type :Chained('base') :Args(1) {
  my ( $self, $c, $type ) = @_;
  $c->stash->{ideas} = $c->stash->{ideas}->search_rs({
    type => $type,
  });
}

sub status :Chained('base') :Args(1) {
  my ( $self, $c, $status ) = @_;
  $c->stash->{ideas} = $c->stash->{ideas}->search_rs({
    status => $status
  });
}

sub idea_id : Chained('base') PathPart('idea') CaptureArgs(1) {
  my ( $self, $c, $id ) = @_;
  $c->stash->{idea} = $c->d->rs('Idea')->find($id);
  unless ($c->stash->{idea}) {
    $c->response->redirect($c->chained_uri('Forum','ideas',{ idea_notfound => 1 }));
    return $c->detach;
  }
  $c->add_bc($c->stash->{idea}->title,$c->chained_uri(@{$c->stash->{idea}->u}));
}

sub idea_redirect : Chained('idea_id') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri(@{$c->stash->{idea}->u}));
  return $c->detach;
}

sub idea : Chained('idea_id') PathPart('') Args(1) {
  my ( $self, $c, $key ) = @_;
  $c->bc_index;
  unless ($c->stash->{idea}->key eq $key) {
    $c->response->redirect($c->chained_uri(@{$c->stash->{idea}->u}));
    return $c->detach;
  }
}

sub idea_edit : Chained('idea_id') Args(0) {
  my ( $self, $c ) = @_;
}

sub idea_vote :Chained('idea_id') :CaptureArgs(1) {
  my ( $self, $c, $vote ) = @_;
  $c->stash->{idea}->set_user_vote($c->user,0+$vote);
}

sub idea_vote_view :Chained('idea_vote') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->stash->{x} = {
    vote_count => $c->stash->{idea}->vote_count
  };
  $c->forward( $c->view('JSON') );
}

no Moose;
__PACKAGE__->meta->make_immutable;
