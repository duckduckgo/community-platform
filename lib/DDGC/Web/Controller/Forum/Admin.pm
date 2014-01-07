package DDGC::Web::Controller::Forum::Admin;
# ABSTRACT: Forum admin functions

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

sub base : Chained('/forum/base') PathPart('admin') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  if (!$c->user) {
    $c->response->redirect($c->chained_uri('My','login'));
    return $c->detach;
  }
  if (!$c->user->is('forum_manager')) {
    $c->response->redirect($c->chained_uri('Root','index',{
      access_denied => 1,
    }));
    return $c->detach;
  }
}

sub moderations : Chained('base') Args(0) {
  my ( $self, $c ) = @_;

  $c->stash->{moderations} = [sort {
    $a->created <=> $b->created
  } map {
    ($c->d->rs($_)->search({
      ghosted => 1,
      checked => undef,
    })->all)
  } qw( Idea Thread Comment )];
  $c->stash->{moderations_i_params} = join(',',map {
    $_->i_param
  } @{$c->stash->{moderations}});
  my @approve = defined $c->req->param('approve')
    ? split(',',scalar $c->req->param('approve')) : ();
  my @approve_content = defined $c->req->param('approve_content')
    ? split(',',scalar $c->req->param('approve_content')) : ();
  my @deny = defined $c->req->param('deny')
    ? split(',',scalar $c->req->param('deny')) : ();
  my @all = (@approve, @approve_content, @deny);
  if (@all) {
    eval {
      for (@approve,@approve_content) {
        $c->ddgc->get_by_i_param($_)->ghosted_checked_by($c->user,0);
        $c->ddgc->get_by_i_param($_)->update;
      }
      for (@approve) {
        my $user = $c->ddgc->get_by_i_param($_)->user;
        $user->ghosted(0);
        $user->update;
      }
      for (@deny) {
        $c->ddgc->get_by_i_param($_)->ghosted_checked_by($c->user,1);
        $c->ddgc->get_by_i_param($_)->update;
      }
    };
    if ($@) {
      $c->stash->{x} = { error => $@ };
    } else {
      $c->stash->{x} = { ok => 1 };
    }
    $c->forward('View::JSON');
    return $c->detach;
  }
}

sub reports : Chained('base') Args(0) {
  my ( $self, $c ) = @_;

  $c->stash->{reports} = [sort {
    $a->created <=> $b->created
  } map {
    ($c->d->rs($_)->search({
      reported => { '!=' => '[]' },
    })->all)
  } qw( Idea Thread Comment )];
}

no Moose;
__PACKAGE__->meta->make_immutable;
