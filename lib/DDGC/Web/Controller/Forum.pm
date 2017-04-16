package DDGC::Web::Controller::Forum;
# ABSTRACT: 

use Moose;
BEGIN {extends 'Catalyst::Controller'; }

use Scalar::Util qw/ looks_like_number /;

use namespace::autoclean;

sub base : Chained('/base') PathPart('forum') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Forum", $c->chained_uri('Forum', 'index'));
  $c->stash->{page_class} = "page-forums  texture";
  $c->stash->{title} = 'DuckDuckGo Forums';
  $c->stash->{is_admin} = $c->user && $c->user->admin;

  if ($c->user && $c->user->is('forum_manager')) {
    $c->stash->{moderations_available} =
      $c->d->rs('Comment')->search({
        'me.ghosted' => 1,
        'me.checked' => undef,
        -not => { '-and' => {
          'me.context' => 'DDGC::DB::Result::Thread',
          'me.parent_id' => undef,
        }}
      }, { cache_for => 30 })->count +
      $c->d->rs('Idea')->search({
        'me.ghosted' => 1,
        'me.checked' => undef,
      }, { cache_for => 30 })->count +
      $c->d->rs('Thread')->search({
        'me.ghosted' => 1,
        'me.checked' => undef,
      }, { cache_for => 30 })->count;

    $c->stash->{reports_available} =
      $c->d->rs('User::Report')->search({
        'me.checked' => undef,
        'me.ignore' => 0,
      }, { cache_for => 60 })->count;
   }


}

sub userbase : Chained('base') PathPart('') CaptureArgs(0) {
  my ( $self, $c ) = @_;
  push @{$c->stash->{template_layout}}, 'forum/base.tx';  
}

sub get_sticky_threads {
  my ( $self, $c ) = @_;
  $c->stash->{sticky_threads} = [ $c->d->rs('Thread')->search_rs({
    sticky => 1,
    forum  => $c->stash->{forum_index} // 1,
  },{
    cache_for => 3600,
  })->all ];
}

sub set_grouped_comments {
  my ( $self, $c, $action, $rs, @args ) = @_;
  $c->stash->{grouped_comments} = $c->table(
    $rs,['Forum',$action,@args],[],
    default_pagesize => 15,
    default_sorting => defined $c->stash->{default_sorting} ? $c->stash->{default_sorting} : '-me.updated',
    id => 'forum_threadlist_'.$action,
    defined $c->stash->{sorting_options} ? (sorting_options => $c->stash->{sorting_options}) : (),
  );
}

sub index : Chained('userbase') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
  $c->response->redirect($c->chained_uri('Forum','general'));
  return $c->detach;
}

sub general : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->stash->{forum_index} = $c->d->config->id_for_forum('general');
  $c->add_bc($c->d->config->forums->{$c->stash->{forum_index}}->{name});
  $self->set_grouped_comments($c,'general',$c->d->forum->comments_grouped_general_threads);
  $self->get_sticky_threads($c);
}

sub internal : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->stash->{forum_index} = $c->d->config->id_for_forum('internal');
  $c->add_bc($c->d->config->forums->{$c->stash->{forum_index}}->{name});
  if (!$c->d->forum->allow_user($c->stash->{forum_index}, $c->user)) {
    $c->response->redirect($c->chained_uri('Forum','general',{ thread_notallowed => 1 }));
    return $c->detach;
  }
  $self->set_grouped_comments($c,'admins',$c->d->forum->comments_grouped_admin_threads);
  $self->get_sticky_threads($c);
}

sub community_leaders : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->stash->{forum_index} = $c->d->config->id_for_forum('community');
  $c->add_bc($c->d->config->forums->{$c->stash->{forum_index}}->{name});
  if (!$c->d->forum->allow_user($c->stash->{forum_index}, $c->user)) {
    $c->response->redirect($c->chained_uri('Forum','general',{ thread_notallowed => 1 }));
    return $c->detach;
  }
  $self->set_grouped_comments($c,'community_leaders',$c->d->forum->comments_grouped_community_leaders_threads);
  $self->get_sticky_threads($c);
}

sub special : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri('Forum','general', { termporarily_disabled => 1 } ));
  $c->stash->{forum_index} = $c->d->config->id_for_forum('special');
  $c->add_bc($c->d->config->forums->{$c->stash->{forum_index}}->{name});
  if (!$c->d->forum->allow_user($c->stash->{forum_index}, $c->user)) {
    $c->response->redirect($c->chained_uri('Forum','general',{ thread_notallowed => 1 }));
    return $c->detach;
  }
  $self->set_grouped_comments($c,'special',$c->d->forum->comments_grouped_special_threads);
  $self->get_sticky_threads($c);
}

sub ideas : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest idea comments");
  $self->set_grouped_comments($c,'ideas',$c->d->forum->comments_grouped_ideas);
}

sub all : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest comments");
  $self->set_grouped_comments($c,'all',$c->d->forum->comments_grouped_for_user($c->user));
}

sub blog : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest company blog comments");
  $self->set_grouped_comments($c,'blog',$c->d->forum->comments_grouped_company_blog);
  $self->get_sticky_threads($c);
}

sub user_blog : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest user blog comments");
  $self->set_grouped_comments($c,'user_blog',$c->d->forum->comments_grouped_user_blog);
  $self->get_sticky_threads($c);
}

sub translation : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc("Latest translation comments");
  $self->set_grouped_comments($c,'translation',$c->d->forum->comments_grouped_translation);
  $self->get_sticky_threads($c);
}

sub search : Chained('userbase') Args(0) {
  my ( $self, $c ) = @_;

  $c->add_bc('Search');

  $c->stash->{query} = $c->req->params->{q};
  return unless length($c->stash->{query});

  my ($threads, $threads_rs, $order_by) = $c->d->forum->search_engine->rs(
      $c,
      $c->stash->{query},
      $c->d->forum->threads_for_user($c->user),
  );

  $c->stash->{results} = $threads;
  $c->stash->{default_sorting} = 'id';
  $c->stash->{sorting_options} = [{
          label => 'Last Update',
          sorting => '-me.updated',
      },{
          label => 'Relevance',
          sorting => 'id',
          order_by => $order_by,
      }] if defined $order_by;
  $self->set_grouped_comments($c,'search',$threads_rs,{ q => $c->stash->{query} })
    if defined $threads_rs;
}

sub suggest : Chained('base') Args(0) {
    my ($self, $c) = @_;
    my $result;

    $c->stash->{not_last_url} = 1;

    if (length $c->req->params->{q} < 4) {
      $result = [];
    }
    else {
      @{$result} = $c->d->search->topic_suggest($c->req->params->{q});
    }

    $c->stash->{x} = $result;
    $c->forward($c->view('JSON'));
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
    $c->response->redirect($c->chained_uri('Forum','general',{ thread_notfound => 1 }));
    return $c->detach;
  }

  if ($c->stash->{thread}->ghosted &&
     ($c->stash->{thread}->checked || $c->stash->{thread}->comment->checked) &&
     (!$c->user || (!$c->user->admin && $c->stash->{thread}->users_id != $c->user->id))) {
    $c->response->redirect($c->chained_uri('Forum','general',{ thread_notfound => 1 }));
    return $c->detach;
  }
  $c->stash->{forum_index} = $c->stash->{thread}->forum;
  if ($c->stash->{thread}->forum eq $c->d->config->id_for_forum('special')) {
    if (!$c->user) {
      $c->response->redirect($c->chained_uri('My','login'));
      return $c->detach;
    }
    $c->{stash}->{campaign_info} = undef;
    $c->d->rs('User::CampaignNotice')->find_or_create( { users_id => $c->user->id, thread_id => $c->stash->{thread}->id } );
  }
  else {
    if (!$c->d->forum->allow_user($c->stash->{forum_index}, $c->user)) {
      $c->response->redirect($c->chained_uri('Forum','general',{ thread_notallowed => 1 }));
      return $c->detach;
    }
  }
  if ($c->stash->{thread}->migrated_to_idea) {
    $c->response->redirect($c->chained_uri('Ideas','idea',$c->stash->{thread}->migrated_to_idea));
    return $c->detach;
  }
  $c->stash->{title} = $c->stash->{thread}->title;
  $self->get_sticky_threads($c);
}

sub thread_redirect : Chained('thread_id') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri(@{$c->stash->{thread}->u}));
  return $c->detach;
}

sub thread : Chained('thread_id') PathPart('') Args(1) {
  my ( $self, $c, $key ) = @_;
  if (defined $c->req->params->{close} && $c->user->admin) {
    $c->require_action_token;
    $c->stash->{thread}->readonly($c->req->params->{close});
    $c->stash->{thread}->update;
  }
  if (defined $c->req->params->{sticky} && $c->user->admin) {
    $c->require_action_token;
    $c->stash->{thread}->sticky($c->req->params->{sticky});
    $c->stash->{thread}->update;
  }
  if ($c->user && $c->req->params->{unfollow}) {
    $c->require_action_token;
    $c->user->delete_context_notification($c->req->params->{unfollow},$c->stash->{thread});
  } elsif ($c->user && $c->req->params->{follow}){
    $c->require_action_token;
    $c->user->add_context_notification($c->req->params->{follow},$c->stash->{thread});
  }
  unless ($c->stash->{thread}->key eq $key) {
    $c->response->redirect($c->chained_uri(@{$c->stash->{thread}->u}));
    return $c->detach;
  }
  $c->add_bc($c->d->config->forums->{$c->stash->{thread}->forum}->{name},
    $c->chained_uri(
      'Forum',
      $c->d->config->forums->{$c->stash->{thread}->forum}->{url},
  ));
  $c->add_bc($c->stash->{title});
  $c->stash->{no_reply} = 1 if $c->stash->{thread}->readonly;
}

sub migrate_to_idea : Chained('userbase') PathPart('migrate') Args(1) {
  my ( $self, $c, $id ) = @_;
  my $thread = $c->d->rs('Thread')->find($id+0);
  if ($thread && $c->user && $c->user->is('forum_manager')) {
    $c->require_action_token;
    my $idea = $thread->migrate_to_ideas;
    if ($idea) {
      $c->response->redirect($c->chained_uri(@{$idea->u}));
      return $c->detach;
    }
    $c->response->redirect($c->chained_uri(@{$thread->u}));
    return $c->detach;
  }
}

# /forum/comment/$id
sub comment_id : Chained('comment_view') PathPart('comment') CaptureArgs(1) {
  my ( $self, $c, $id ) = @_;

  $id += 0 if $id =~ /^[0-9]/;
  if (!looks_like_number($id)) {
    my $thread = $c->d->rs('Thread')->search({
      key => $id,
      forum => $c->d->config->id_for_forum('general'),
    })->one_row;
    if ($thread) {
      $c->response->redirect($c->chained_uri('Forum','thread',$thread->id,$thread->key));
      return $c->detach;
    }
    $c->response->redirect($c->chained_uri('Forum','general',{ comment_notfound => 1 }));
    return $c->detach;
  }

  $c->stash->{thread} = $c->d->rs('Comment')->find($id);
  unless ($c->stash->{thread}) {
    $c->response->redirect($c->chained_uri('Forum','general',{ comment_notfound => 1 }));
    return $c->detach;
  }
  my $t = $c->stash->{thread}->thread;
  if ($t) {
    $c->stash->{forum_index} = $t->forum // 1;
    if (!$c->d->forum->allow_user($c->stash->{forum_index}, $c->user)) {
      $c->response->redirect($c->chained_uri('Forum','general',{ thread_notallowed => 1 }));
      return $c->detach;
    }
    $self->get_sticky_threads($c);
  }
  $c->add_bc('Comment #'.$c->stash->{thread}->id,$c->chained_uri('Forum','comment',
    $c->stash->{thread}->id));
}

sub comment : Chained('comment_id') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
}

1;

