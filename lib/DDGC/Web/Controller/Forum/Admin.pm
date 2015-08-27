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
  push @{$c->stash->{template_layout}}, 'forum/admin/base.tx';  
}

sub index : Chained('base') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
}

sub forum : Chained('base') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
  $c->stash->{grouped_comments} = $c->table(
    $c->d->forum->comments_grouped_threads(2),['Forum::Admin','forum'],[],
    default_pagesize => 15,
    default_sorting => '-me.updated',
    id => 'forum_threadlist_forum_admin',
  );
}

sub moderations : Chained('base') Args(0) {
  my ( $self, $c ) = @_;

  $c->stash->{title} = 'Moderations';
  $c->add_bc($c->stash->{title}, '');

  my @approve = defined $c->req->param('approve')
    ? split(',',scalar $c->req->param('approve')) : ();
  my @approve_content = defined $c->req->param('approve_content')
    ? split(',',scalar $c->req->param('approve_content')) : ();
  my @deny = defined $c->req->param('deny')
    ? split(',',scalar $c->req->param('deny')) : ();
  my @all = (@approve, @approve_content, @deny);
  if (@all) {
    $c->require_action_token;
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

  if ($c->req->param('ignore_all_from_user') && $c->req->param('user_id')) {
    $c->require_action_token;
    my $user = $c->d->rs('User')->find($c->req->param('user_id'));
    if ($user) {

      for my $contrib_type (qw/ Thread Idea Comment /) {
        $c->d->rs( $contrib_type )->search_rs({
          checked => undef, users_id => $c->req->param('user_id'),
        })->update({ checked => $c->user->id, ghosted => 1 });
      }

      $user->ignore(1);
      $user->ghosted(1);
      $user->update;
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

  $c->stash->{title} = 'Reports';
  $c->add_bc($c->stash->{title}, '');

  my @ghost = defined $c->req->param('ghost')
    ? split(',',scalar $c->req->param('ghost')) : ();
  my @ghost_content = defined $c->req->param('ghost_content')
    ? split(',',scalar $c->req->param('ghost_content')) : ();
  my @checked = defined $c->req->param('checked')
    ? split(',',scalar $c->req->param('checked')) : ();
  my @delete;
  if ($c->user->admin) {
    @delete = defined $c->req->param('delete')
      ? split(',',scalar $c->req->param('delete')) : ();
  }

  my @all = (@ghost, @ghost_content, @checked, @delete);

  if (@all) {
    eval {
      for (@ghost,@ghost_content) {
        my $r = $c->d->rs('User::Report')->find($_);
        my $o = $r->get_context_obj;
        $o->ghosted_checked_by($c->user,1);
        $o->update;
      }
      for (@ghost) {
        my $r = $c->d->rs('User::Report')->find($_);
        my $u = $r->get_context_obj->user;
        $u->ghosted(1);
        $u->update;
      }
      for (@all) {
        my $r = $c->d->rs('User::Report')->find($_);
        $r->checked($c->user->id);
        $r->update;
      }
      for (@delete) {
        $c->d->rs('User::Report')->find($_)->delete;
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

  $c->stash->{show_ignore} = $c->req->param('show_ignore') ? 1 : 0;
  $c->stash->{show_checked} = ($c->user->admin && $c->req->param('show_checked')) ? 1 : 0;

  unless ($c->req->param('json')) {
    if ($c->stash->{show_checked}) {
      $c->stash->{reports} = [ $c->d->rs('User::Report')->search_rs({
        'me.checked' => { '!=' => undef },
      },{
        order_by => { -desc => 'me.created' },
      })->prefetch_all->all ];
    } else {
      $c->stash->{reports} = [ $c->d->rs('User::Report')->search_rs({
        'me.checked' => undef,
        'me.ignore' => $c->stash->{show_ignore},
      },{
        order_by => { -desc => 'me.created' },
      })->prefetch_all->all ];
    }
  }
}

no Moose;
__PACKAGE__->meta->make_immutable;
