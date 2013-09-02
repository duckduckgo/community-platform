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
}

sub all : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest comments");
  $self->set_grouped_comments($c,'all',$c->d->forum->comments_grouped);
}

sub blog : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest blog comments");
  $self->set_grouped_comments($c,'blog',$c->d->forum->comments_grouped_blog);
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
  $c->add_bc($c->stash->{thread}->title,$c->chained_uri('Forum','thread',
    $c->stash->{thread}->id,$c->stash->{thread}->key));
}

sub thread_redirect : Chained('thread_id') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri('Forum','thread',
    $c->stash->{thread}->id,$c->stash->{thread}->key));
  return $c->detach;
}

sub thread : Chained('thread_id') PathPart('') Args(1) {
  my ( $self, $c, $key ) = @_;
  $c->bc_index;

  if (defined $c->req->params->{close} && $c->user->admin) {
    $c->stash->{thread}->readonly($c->req->params->{close});
    $c->stash->{thread}->update;
  }
  if (defined $c->req->params->{sticky} && $c->user->admin) {
    $c->stash->{thread}->sticky($c->req->params->{sticky});
    $c->stash->{thread}->update;
  }

  unless ($c->stash->{thread}->key eq $key) {
    $c->response->redirect($c->chained_uri('Forum','thread',
      $c->stash->{thread}->id,$c->stash->{thread}->key));
  }
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

# /forum/thread/edit/$id
sub edit : Chained('thread') Args(0) {
  my ( $self, $c ) = @_;
  push @{$c->stash->{breadcrumb}}, ('Edit');
}

sub update : Chained('thread') Args(0) {
  my ( $self, $c ) = @_;
  return unless $c->stash->{is_owner} && $c->req->params->{text};
  $c->stash->{thread}->text($c->req->params->{text});
  $c->stash->{thread}->update;
  $c->response->redirect($c->chained_uri('Forum','view',$c->stash->{thread}->url));
}

sub status : Chained('thread') Args(0) {
  my ( $self, $c ) = @_;
  return unless $c->stash->{is_owner} && exists $c->req->params->{status};
  my %statuses = reverse $c->stash->{thread}->statuses('hash');
  return unless exists $statuses{lc($c->req->params->{status})} || $c->req->params->{status} == 0 || $c->req->params->{status} == 1;
  my $category = $c->stash->{thread}->category_key;
  my %data = $c->stash->{thread}->data ? %{$c->stash->{thread}->data} : ();

  my $status = $statuses{lc($c->req->params->{status})} ? $statuses{lc($c->req->params->{status})} : $c->req->params->{status};

  $data{"${category}_status_id"} = $status;
  $c->stash->{thread}->data(\%data);
  $c->stash->{thread}->update;
  $c->response->redirect($c->chained_uri('Forum','view',$c->stash->{thread}->url));
}

# /forum/newthread
sub newthread : Chained('base') Args(0) {
    my ( $self, $c ) = @_;
    $c->add_bc("New Thread");

    if ($c->req->params->{post_thread} && (!$c->req->params->{title} || !$c->req->params->{text})) {
        $c->stash->{error} = 'One or more fields were empty.';
    } elsif ($c->req->params->{post_thread}) {
        my $thread = $c->d->forum->add_thread(
            $c->user,
            $c->req->params->{text},
            title => $c->req->params->{title},
        );
        $c->response->redirect($c->chained_uri(@{$thread->u}));
        return $c->detach;
    }
}

sub delete : Chained('base') Args(1) {
    my ( $self, $c, $id ) = @_;
    my $thread = $c->d->rs('Thread')->single({ id => $id });
    return unless $thread;
    return unless $c->user && ($c->user->admin || $c->user->id == $thread->user->id);
    $c->d->rs('Comment')->search({ context => "DDGC::DB::Result::Thread", context_id => $id })->delete();
    $thread->delete();
    $c->response->redirect($c->chained_uri('Forum','index'));
}

1;

