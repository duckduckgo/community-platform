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
sub thread : Chained('base') Args(1) {
  my ( $self, $c, $id ) = @_;
  my @idstr = split('-',$id);

  my $thread = $c->d->forum->get_thread($idstr[0]);

  my $url = lc($thread->title);
  $url =~ s/[^a-z0-9]+/-/g; $url =~ s/-$//;
  $url = "$idstr[0]-$url";
  print "$url, $id";

  $c->response->redirect($c->chained_uri('Forum','thread',$url)) if $url ne $id;
  $c->stash->{thread} = $thread if $thread;
}

sub loremthread : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  my $thread = $c->d->rs('Thread')->new({
      title => "Hello, World!",
      text => $text,
      users_id => 1,
      category => "idea",
  });
  $thread->insert;
  $c->d->db->txn_do(sub { $thread->update });
}

1;

