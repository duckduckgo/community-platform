package DDGC::Web::Controller::Forum;
# ABSTRACT: 

use Moose;
BEGIN {extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base : Chained('/base') PathPart('forum') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Forum", $c->chained_uri('Forum', 'index'));
  $c->stash->{page_class} = "page-forums  texture";
  $c->stash->{title} = 'DuckDuckGo Forums';
  $c->stash->{is_admin} = $c->user && $c->user->admin;
}

sub userbase : Chained('base') PathPart('') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  push @{$c->stash->{template_layout}}, 'forum/base.tx';  
  $c->stash->{sticky_threads} = $c->d->rs('Thread')->search_rs({
    sticky => 1,
  },{
    cache_for => 3600,
  });
}

sub set_grouped_comments {
  my ( $self, $c, $action, $rs, @args ) = @_;
  $c->stash->{grouped_comments} = $c->table(
    $rs,['Forum',$action,@args],[],
    default_pagesize => 15,
    default_sorting => '-me.updated',
    id => 'forum_threadlist_'.$action,
  );
}

sub index : Chained('userbase') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
  $self->set_grouped_comments($c,'index',$c->d->forum->comments_grouped_threads);
  $c->stash->{forum_index} = 1;
}

sub ideas : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest idea comments");
  $self->set_grouped_comments($c,'ideas',$c->d->forum->comments_grouped_ideas);
}

sub all : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest comments");
  $self->set_grouped_comments($c,'all',$c->d->forum->comments_grouped);
}

sub blog : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest company blog comments");
  $self->set_grouped_comments($c,'blog',$c->d->forum->comments_grouped_company_blog);
}

sub user_blog : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest user blog comments");
  $self->set_grouped_comments($c,'user_blog',$c->d->forum->comments_grouped_user_blog);
}

sub translation : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest translation comments");
  $self->set_grouped_comments($c,'translation',$c->d->forum->comments_grouped_translation);
}

sub search : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;

  $c->add_bc('Search');

  $c->stash->{query} = $c->req->params->{q};
  return unless length($c->stash->{query});

  $c->stash->{result} = $c->d->forum->search(q => $c->stash->{query});
  use DDP; p $c->stash->{result}->results;
  1
}

sub thread_view : Chained('userbase') PathPart('') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  push @{$c->stash->{template_layout}}, 'forum/thread.tx';
}

sub comment_view : Chained('userbase') PathPart('') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  push @{$c->stash->{template_layout}}, 'forum/comment.tx';
}

# /forum/thread/$id
sub thread_id : Chained('thread_view') PathPart('thread') CaptureArgs(1) {
  my ( $self, $c, $id ) = @_;
  $c->stash->{thread} = $c->d->rs('Thread')->find($id+0);
  unless ($c->stash->{thread}) {
    $c->response->redirect($c->chained_uri('Forum','index',{ thread_notfound => 1 }));
    return $c->detach;
  }
  $c->add_bc($c->stash->{thread}->title,$c->chained_uri(@{$c->stash->{thread}->u}));
  $c->stash->{title} = $c->stash->{thread}->title;
}

sub thread_redirect : Chained('thread_id') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri(@{$c->stash->{thread}->u}));
  return $c->detach;
}

sub thread : Chained('thread_id') PathPart('') Args(1) {
  my ( $self, $c, $key ) = @_;
  if (defined $c->req->params->{close} && $c->user->admin) {
    $c->stash->{thread}->readonly($c->req->params->{close});
    $c->stash->{thread}->update;
  }
  if (defined $c->req->params->{sticky} && $c->user->admin) {
    $c->stash->{thread}->sticky($c->req->params->{sticky});
    $c->stash->{thread}->update;
  }
  if ($c->user && $c->req->params->{unfollow}) {
    $c->user->delete_context_notification($c->req->params->{unfollow},$c->stash->{thread});
  } elsif ($c->user && $c->req->params->{follow}){
    $c->user->add_context_notification($c->req->params->{follow},$c->stash->{thread});
  }
  unless ($c->stash->{thread}->key eq $key) {
    $c->response->redirect($c->chained_uri(@{$c->stash->{thread}->u}));
    return $c->detach;
  }
  $c->bc_index;
  $c->stash->{no_reply} = 1 if $c->stash->{thread}->readonly;
}

# /forum/comment/$id
sub comment_id : Chained('comment_view') PathPart('comment') CaptureArgs(1) {
  my ( $self, $c, $id ) = @_;
  $c->stash->{thread} = $c->d->rs('Comment')->find($id);
  unless ($c->stash->{thread}) {
    $c->response->redirect($c->chained_uri('Forum','index',{ comment_notfound => 1 }));
    return $c->detach;
  }
  $c->add_bc('Comment #'.$c->stash->{thread}->id,$c->chained_uri('Forum','comment',
    $c->stash->{thread}->id));
}

sub comment : Chained('comment_id') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
}

1;

