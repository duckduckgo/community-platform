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

sub index : Chained('base') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
}

sub moderations : Chained('base') Args(0) {
  my ( $self, $c ) = @_;

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
        my $obj = $c->ddgc->get_by_i_param($_);
        $obj->ghosted_checked_by($c->user,0);
        $obj->update;
      }
      for (@approve) {
        my $user = $c->ddgc->get_by_i_param($_)->user;
        $user->ghosted(0);
        $user->update;
      }
      for (@deny) {
        my $obj = $c->ddgc->get_by_i_param($_);
        $obj->ghosted_checked_by($c->user,1);
        $obj->update;
      }
    };
    if ($@) {
      $c->stash->{x} = { error => $@ };
    } else {
      $c->stash->{x} = { ok => 1 };
    }
    if ($c->req->param('json')) {
      $c->forward('View::JSON');
      return $c->detach;
    }
  }

  unless ($c->req->param('json')) {
    $c->stash->{moderations} = [sort {
      $a->created <=> $b->created
    } ( ( map {
      $c->d->rs($_)->search({
        'me.ghosted', 1,
        'me.checked', undef,
      })->prefetch_all->all
    } qw( Idea Thread ) ),(
      $c->d->rs('Comment')->search({
        'me.ghosted', 1,
        'me.checked', undef,
        '-not' => { '-and' => {
          'me.context', 'DDGC::DB::Result::Thread',
          'me.parent_id', undef,
        }},
      })->prefetch_all->all 
    ) ) ];
    $c->stash->{moderations_i_params} = join(',',map {
      $_->i_param
    } @{$c->stash->{moderations}});
  }
}

sub reports : Chained('base') Args(0) {
  my ( $self, $c ) = @_;

  $c->stash->{reports} = $c->d->rs('User::Report')->search_rs({},{
    order_by => { -desc => 'created' },
  })->prefetch_all;
}

no Moose;
__PACKAGE__->meta->make_immutable;
