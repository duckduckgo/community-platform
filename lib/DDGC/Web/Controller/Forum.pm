package DDGC::Web::Controller::Forum;

use Moose;
BEGIN {extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base : Chained('/base') PathPart('forum') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  push @{$c->stash->{template_layout}}, 'forum/base.tx';
  $c->add_bc("Forum", $c->chained_uri('Forum', 'index'));
  $c->stash->{page_class} = "page-forums  texture";
  $c->stash->{title} = 'DuckDuckGo Forums';
  $c->stash->{is_admin} = $c->user && $c->user->admin;
  $c->stash->{sticky_threads} = $c->d->rs('Thread')->search_rs({
    sticky => 1,
  });
}

sub set_grouped_comments {
  my ( $self, $c, $action, $rs ) = @_;
  $c->stash->{grouped_comments} = $c->table(
    $rs->search_rs({},{
      order_by => { -desc => 'me.created' },
    }),['Forum',$action],[],
    default_pagesize => 15,
    id => 'forum_threadlist_'.$action,
  );
}

sub index : Chained('base') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
  $self->set_grouped_comments($c,'index',$c->d->forum->comments_grouped_threads);
  $c->stash->{forum_index} = 1;
}

sub ideas : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest idea comments");
  $self->set_grouped_comments($c,'ideas',$c->d->forum->comments_grouped_ideas);
}

sub all : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest comments");
  $self->set_grouped_comments($c,'all',$c->d->forum->comments_grouped);
}

sub blog : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest company blog comments");
  $self->set_grouped_comments($c,'blog',$c->d->forum->comments_grouped_company_blog);
}

sub user_blog : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest user blog comments");
  $self->set_grouped_comments($c,'user_blog',$c->d->forum->comments_grouped_user_blog);
}

sub translation : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest translation comments");
  $self->set_grouped_comments($c,'translation',$c->d->forum->comments_grouped_translation);
}

# /forum/search/
sub search : Chained('base') Args(0) {
  my ( $self, $c, $pagenum ) = @_;

  $c->stash->{query} = $c->req->params->{q};
  return unless $c->stash->{query};

  $c->stash->{results} = $c->d->forum->search($c->req->params->{q});
  unless ($c->stash->{results}) {
    $c->stash->{error} = "Unable to connect to search server. Please try again, and if this problem persists, please contact <a href='mailto:ops\@duckduckgo.com'>ops\@duckduckgo.com</a>";
    return;
  }
}

sub thread_view : Chained('base') PathPart('') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  push @{$c->stash->{template_layout}}, 'forum/thread.tx';
}

# /forum/thread/$id
sub thread_id : Chained('thread_view') PathPart('thread') CaptureArgs(1) {
  my ( $self, $c, $id ) = @_;
  $c->stash->{thread} = $c->d->rs('Thread')->find($id);
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
  unless ($c->stash->{thread}->key eq $key) {
    $c->response->redirect($c->chained_uri(@{$c->stash->{thread}->u}));
    return $c->detach;
  }
  $c->bc_index;
  $c->stash->{no_reply} = 1 if $c->stash->{thread}->readonly;
}

# /forum/comment/$id
sub comment_id : Chained('thread_view') PathPart('comment') CaptureArgs(1) {
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

