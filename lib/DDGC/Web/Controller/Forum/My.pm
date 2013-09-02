package DDGC::Web::Controller::Forum::My;
# ABSTRACT: Forum user functions

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

sub base : Chained('/forum/base') PathPart('my') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  if (!$c->user) {
    $c->response->redirect($c->chained_uri('My','login'));
    return $c->detach;
  }
}

# /forum/my/newthread
sub newthread : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("New Thread");
  if ($c->req->params->{post_thread} && (!$c->req->params->{title} || !$c->req->params->{content})) {
    $c->stash->{error} = 'One or more fields were empty.';
  } elsif ($c->req->params->{post_thread}) {
    my $thread = $c->d->forum->add_thread(
      $c->user,
      $c->req->params->{content},
      title => $c->req->params->{title},
    );
    $c->response->redirect($c->chained_uri(@{$thread->u}));
    return $c->detach;
  }
}

sub thread : Chained('base') CaptureArgs(1) {
  my ( $self, $c, $id ) = @_;
  $c->stash->{thread} = $c->d->rs('Thread')->find($id);
  unless ($c->stash->{thread}) {
    $c->response->redirect($c->chained_uri('Forum','index',{ thread_notfound => 1 }));
    return $c->detach;
  }
  unless ($c->user->admin || $c->stash->{thread}->users_id == $c->user->id) {
    $c->response->redirect($c->chained_uri('Forum','index',{ thread_notallowed => 1 }));
    return $c->detach;
  }
}

sub edit : Chained('thread') Args(0) {
  my ( $self, $c ) = @_;

  if ($c->req->params->{post_thread}) {
    if ($c->req->params->{title} && $c->req->params->{content}) {
      $c->stash->{thread}->data({}) unless $c->stash->{thread}->data;
      $c->stash->{thread}->data->{revisions} = [] unless defined $c->stash->{thread}->data->{revisions};
      push @{$c->stash->{thread}->data->{revisions}}, {
        title => $c->stash->{thread}->title,
        content => $c->stash->{thread}->content,
        updated => $c->stash->{thread}->updated,
      };
      $c->stash->{thread}->title($c->req->params->{title});
      $c->stash->{thread}->update;
      $c->stash->{thread}->comment->content($c->req->params->{content});
      $c->stash->{thread}->comment->update;
      $c->response->redirect($c->chained_uri(@{$c->stash->{thread}->u},{
        update_successful => 1,
      }));
    } else {
      $c->stash->{error} = 'One or more fields were empty.';
    }
  }

}

sub delete : Chained('thread') Args(0) {
  my ( $self, $c ) = @_;
  if ($c->req->params->{i_am_sure}) {
    my $id = $c->stash->{thread}->id;
    $c->d->db->txn_do(sub {
      $c->stash->{thread}->delete();
      $c->d->rs('Comment')->search({ context => "DDGC::DB::Result::Thread", context_id => $id })->delete();
    });
    $c->response->redirect($c->chained_uri('Forum','index'));
    return $c->detach;
  }
}

no Moose;
__PACKAGE__->meta->make_immutable;
