package DDGC::Web::Controller::Forum;

use Moose;
use namespace::autoclean;

use DDP;

BEGIN {extends 'Catalyst::Controller'; }

sub base : Chained('/base') PathPart('forum') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->stash->{is_admin} = $c->user && $c->user->admin;
  use DDP;p($c->request);
  #$c->response->redirect('/'.$c->request->path);
}

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

# /forum/index/
sub index : Chained('base') Args(0) {
  my ( $self, $c, $pagenum ) = @_;
  $pagenum = $c->req->params->{page} ? $c->req->params->{page} : 1;
  return unless $pagenum=~/^\d+$/;

  $c->stash->{page} = $pagenum;
  $c->pager_init($c->action, 20);
  $c->stash->{threads} = $c->d->forum->get_threads($pagenum);
  unless ($c->stash->{threads}->count) {
      $c->stash->{error} = "Cannot display page";
  }
}

# /forum/thread/$id
sub thread : Chained('base') CaptureArgs(1) {
  my ( $self, $c, $id ) = @_;
  my @idstr = split('-',$id);
  $c->stash->{thread} = $c->d->forum->get_thread($idstr[0]);
  $c->stash->{thread_html} = $c->stash->{thread}->render_html($c->d);
  my $url = $c->stash->{thread}->url;
  $c->response->redirect($c->chained_uri('Forum','view',$url)) if $url ne $id;
  $c->stash->{is_owner} = ($c->user && ($c->user->admin || $c->user->id == $c->stash->{thread}->users_id)) ? 1 : 0;
}

sub view : Chained('thread') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
}

# /forum/thread/edit/$id
sub edit : Chained('thread') Args(0) {
  my ( $self, $c ) = @_;
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

# /forum/makethread (actually create a thread)
sub makethread : Chained('base') Args(0) {
    my ( $self, $c ) = @_;

    unless ($c->user) {
        $c->stash->{error} = 'You are not logged in.';
        return;
    }
    unless ($c->req->params->{title} && $c->req->params->{text} && $c->req->params->{category_id}) {
        $c->stash->{error} = 'One or more fields were empty.';
        return
    }

    my $thread = $c->d->rs('Thread')->new({
        thread_title => $c->req->params->{title},
        text => $c->req->params->{text},
        category_id => $c->req->params->{category_id},
        users_id => $c->user->id,
    });

    my $category = $thread->category_key;
    $thread->data({ "${category}_status_id" => 1 });
    $thread->insert;
    $c->d->db->txn_do(sub { $thread->update });
    $c->response->redirect($c->chained_uri('Forum','view',$thread->url));
}

1;

