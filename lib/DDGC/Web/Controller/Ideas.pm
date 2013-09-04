package DDGC::Web::Controller::Ideas;
# ABSTRACT: Idea controller

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('ideas') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
  push @{$c->stash->{template_layout}}, 'ideas/base.tx';
  $c->add_bc('Instant Answer Ideas',$c->chained_uri('Ideas','index'));
  my $idea_types = $c->d->rs('Idea')->result_class->types;
  my $idea_statuses = $c->d->rs('Idea')->result_class->statuses;
  $c->stash->{idea_types} = [map { [ $_, $idea_types->{$_} ] } sort { $a <=> $b } keys %{$idea_types}];
  $c->stash->{idea_statuses} = [map { [ $_, $idea_statuses->{$_} ] } sort { $a <=> $b } keys %{$idea_statuses}];
  $c->stash->{ideas_rs} = $c->d->rs('Idea')->search_rs({},{
    prefetch => [qw( user ),{
      idea_votes => [qw( user )],
    }]
  });
}

sub add_latest_ideas {
  my ( $self, $c ) = @_;
  $c->stash->{latest_ideas} = $c->d->rs('Idea')->search_rs({},{
    order_by => { -desc => 'me.created' },
    rows => 5,
    page => 1,
  });
}

sub add_ideas_table {
  my ( $self, $c, @args ) = @_;
  $c->stash->{ideas} = $c->table(
    $c->stash->{ideas_rs}->search_rs({},{
      order_by => { -desc => 'me.created' },
    }),['Ideas',@args],[],
    default_pagesize => 15,
    id => 'idealist_'.join('_',@args),
  );
}

sub newidea : Chained('base') Args(0) {
  my ( $self, $c ) = @_;
  $self->add_latest_ideas($c);
  $c->add_bc('New Suggestion');
  if ($c->req->params->{save_idea} && (!$c->req->params->{title} || !$c->req->params->{content})) {
    $c->stash->{error} = 'One or more fields were empty.';
  } elsif ($c->req->params->{save_idea}) {
    my $idea = $c->user->create_related('ideas',{
      title => $c->req->params->{title},
      content => $c->req->params->{content},
      source => $c->req->params->{source},
      type => $c->req->params->{type},
    });
    $c->response->redirect($c->chained_uri(@{$idea->u}));
    return $c->detach;
  }
}

sub index :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $self->add_ideas_table($c,'index');
  $c->bc_index;
}

sub type :Chained('base') :Args(1) {
  my ( $self, $c, $type ) = @_;
  $c->stash->{ideas_rs} = $c->stash->{ideas_rs}->search_rs({
    type => $type,
  });
  $self->add_ideas_table($c,'type',$type);
  $self->add_latest_ideas($c);
  $c->add_bc('Filtered');
}

sub status :Chained('base') :Args(1) {
  my ( $self, $c, $status ) = @_;
  $c->stash->{ideas_rs} = $c->stash->{ideas_rs}->search_rs({
    status => $status,
  });
  $self->add_ideas_table($c,'status',$status);
  $self->add_latest_ideas($c);
  $c->add_bc('Filtered');
}

sub idea_id : Chained('base') PathPart('idea') CaptureArgs(1) {
  my ( $self, $c, $id ) = @_;
  $c->stash->{idea} = $c->d->rs('Idea')->find($id);
  unless ($c->stash->{idea}) {
    $c->response->redirect($c->chained_uri('Ideas','index',{ idea_notfound => 1 }));
    return $c->detach;
  }
  $c->add_bc($c->stash->{idea}->title,$c->chained_uri(@{$c->stash->{idea}->u}));
  $self->add_latest_ideas($c);
}

sub idea_redirect : Chained('idea_id') PathPart('') Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri(@{$c->stash->{idea}->u}));
  return $c->detach;
}

sub idea : Chained('idea_id') PathPart('') Args(1) {
  my ( $self, $c, $key ) = @_;
  $c->bc_index;
  if ($c->user && $c->user->is('idea_manager') && $c->req->params->{change_status}) {
    $c->stash->{idea}->status($c->req->params->{status});
    $c->stash->{idea}->update;
  }
  unless ($c->stash->{idea}->key eq $key) {
    $c->response->redirect($c->chained_uri(@{$c->stash->{idea}->u}));
    return $c->detach;
  }
}

sub edit : Chained('idea_id') Args(0) {
  my ( $self, $c ) = @_;
  unless ($c->user) {
    $c->response->redirect($c->chained_uri('My','login'));
    return $c->detach;
  }
  unless ($c->user->id == $c->stash->{idea}->users_id || $c->user->is('idea_manager')) {
    $c->response->redirect($c->chained_uri(@{$c->stash->{idea}->u}));
    return $c->detach;
  }
  if ($c->req->params->{save_idea} && (!$c->req->params->{title} || !$c->req->params->{content})) {
    $c->stash->{error} = 'One or more fields were empty.';
  } elsif ($c->req->params->{save_idea}) {
    $c->stash->{idea}->data({}) unless $c->stash->{idea}->data;
    $c->stash->{idea}->data->{revisions} = [] unless defined $c->stash->{idea}->data->{revisions};
    push @{$c->stash->{idea}->data->{revisions}}, {
      title => $c->stash->{idea}->title,
      content => $c->stash->{idea}->content,
      source => $c->stash->{idea}->source,
      updated => $c->stash->{idea}->updated,
    };
    if ($c->user->is('idea_manager')) {
      $c->stash->{idea}->type($c->req->params->{type});
    }
    $c->stash->{idea}->title($c->req->params->{title});
    $c->stash->{idea}->content($c->req->params->{content});
    $c->stash->{idea}->source($c->req->params->{source});
    $c->stash->{idea}->update;
    $c->response->redirect($c->chained_uri(@{$c->stash->{idea}->u}));
    return $c->detach;
  }
  $c->add_bc('Edit');
}

sub vote :Chained('idea_id') :CaptureArgs(1) {
  my ( $self, $c, $vote ) = @_;
  $c->stash->{idea}->set_user_vote($c->user,0+$vote);
}

sub vote_view :Chained('vote') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->stash->{x} = {
    vote_count => $c->stash->{idea}->vote_count
  };
  $c->forward( $c->view('JSON') );
}

no Moose;
__PACKAGE__->meta->make_immutable;
