package DDGC::Web::Controller::Forum;

use Moose;
BEGIN {extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base : Chained('/base') PathPart('forum') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Forum", $c->chained_uri('Forum', 'index'));
  $c->stash->{is_admin} = $c->user && $c->user->admin;
  #$c->response->redirect('/'.$c->request->path);
}

# /forum/index/
sub index : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;

  my $rs = $c->d->forum->get_threads;
  $c->stash->{thread_table} = $c->table($rs,['Forum','index'],[], default_pagesize => 20);

  # TODO: Move this to the template
  #unless ($c->stash->{threads}->count && $pagenum == 1) {
  #    $c->stash->{error} = "Cannot display page";
  #}
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

# /forum/thread/$id
sub thread : Chained('base') CaptureArgs(1) {
  my ( $self, $c, $id ) = @_;
  my @idstr = split('-',$id);
  $c->stash->{thread} = $c->d->forum->get_thread($idstr[0]);
  my $url = $c->stash->{thread}->url;
  $c->response->redirect($c->chained_uri('Forum','view',$url)) if $url ne $id;

  $c->stash->{thread_comments} = $c->d->comments('DDGC::DB::Result::Thread', $c->stash->{thread}->id);

  $c->add_bc($c->stash->{thread}->title, $c->stash->{thread}->url);
  $c->bc_index;

  $c->stash->{is_owner} = ($c->user && ($c->user->admin || $c->user->id == $c->stash->{thread}->users_id)) ? 1 : 0;
}

sub view : Chained('thread') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
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
    
    my $thread = $c->d->forum->new_thread(
        user => $c->user,
        title => $c->req->params->{title},
        category_id => $c->req->params->{category_id},
        content => $c->req->params->{text},
    );

    $c->response->redirect($c->chained_uri('Forum','view',$thread->url));
}

1;

