package DDGC::Web::Controller::Forum;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base : Chained('/base') PathPart('forum') CaptureArgs(0) {
  my ( $self, $c ) = @_;
}

my $text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a diam lectus. Sed sit amet ipsum mauris. Maecenas congue ligula ac quam viverra nec consectetur ante hendrerit. Donec et mollis dolor. Praesent et diam eget libero egestas mattis sit amet vitae augue. Nam tincidunt congue enim, ut porta lorem lacinia consectetur. Donec ut libero sed arcu vehicula ultricies a non tortor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ut gravida lorem. Ut turpis felis, pulvinar a semper sed, adipiscing id dolor. Pellentesque auctor nisi id magna consequat sagittis. Curabitur dapibus enim sit amet elit pharetra tincidunt feugiat nisl imperdiet. Ut convallis libero in urna ultrices accumsan. Donec sed odio eros. Donec viverra mi quis quam pulvinar at malesuada arcu rhoncus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In rutrum accumsan ultricies. Mauris vitae nisi at sem facilisis semper ac in est.";

# /forum/index
sub index : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  my @threads = $c->d->forum->get_threads;
  $c->stash->{threads} = \@threads if @threads;
}

# /forum/thread/$id
sub thread : Chained('base') CaptureArgs(1) {
  my ( $self, $c, $id ) = @_;
  my @idstr = split('-',$id);
  $c->stash->{thread} = $c->d->forum->get_thread($idstr[0]);
  my $url = $c->stash->{thread}->url;
#$c->response->redirect($c->chained_uri('Forum','thread',$url)) if $url ne $id; # TODO FIXME TODO : add the redirect back!
  $c->stash->{is_owner} = ($c->user && ($c->user->admin || $c->user->id == $c->stash->{thread}{user}->id)) ? 1 : 0;
  $c->stash->{is_admin} = $c->user && $c->user->admin;
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
  return unless $c->stash->{is_owner};
  $c->stash->{thread}->text($c->req->params->{text});
  $c->stash->{thread}->update;
}

sub status : Chained('thread') Args(0) {
  my ( $self, $c ) = @_;
}

sub loremthread : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  my $thread = $c->d->rs('Thread')->new({
      title => "Hello, World!",
      text => $text,
      users_id => 1,
      category_id => 2,
      data => { idea_status_id => 2 },
  });
  $thread->insert;
  $c->d->db->txn_do(sub { $thread->update });
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
    return unless $c->user;
    return unless $c->req->params->{title} && $c->req->params->{text} && $c->req->params->{category_id};

    print "HELLO??\n";
    my $thread = $c->d->rs('Thread')->new({
        title => $c->req->params->{title},
        text => $c->req->params->{text},
        category_id => $c->req->params->{category_id},
        users_id => $c->user->id,
    });
    my $category = $thread->category_key;
    $thread->data({ "${category}_status_id" => 1 });
    $thread->insert;
    $c->d->db->txn_do(sub { $thread->update });
    $c->response->redirect($c->chained_uri('Forum','thread',$thread->id));
}

1;

