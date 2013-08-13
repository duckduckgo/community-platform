package DDGC::Web::Controller::Feedback;
use Moose;
use DDGC::Feedback::Step;
use DDGC::Feedback::Config;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('feedback') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
}

sub index_redirect :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect('https://duckduckgo.com/feedback');
  return $c->detach;
}

sub feedback :Chained('base') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $feedback ) = @_;
  $c->stash->{feedback_name} = $feedback;
  unless (DDGC::Feedback::Config->can($feedback)) {
    $c->response->redirect('https://duckduckgo.com/feedback');
    return $c->detach;
  }
  my $feedback_config = DDGC::Feedback::Config->$feedback;
  $c->stash->{feedback} = DDGC::Feedback::Step->new_from_config(@{$feedback_config});
}

sub feedback_redirect :Chained('feedback') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri('Feedback','step',$c->stash->{feedback_name},'-'));
}

sub step :Chained('feedback') :PathPart('') :Args(1) {
  my ( $self, $c, $steps_param ) = @_;
  my @steps = split(/-/,$steps_param); shift @steps;
  my $previous_step;
  my $current_step = $c->stash->{feedback};
  for my $step_index (@steps) {
    $previous_step = $current_step;
    $current_step = $current_step->options->[$step_index]->target;
  }
  my $session_key = join('-',@steps).'/'.$c->stash->{feedback_name};
  for (keys %{$c->req->params}) {
    if ($_ =~ m/^option_(\d+)$/) {
      my $next_step_index = $1;
      $previous_step = $current_step;
      $current_step = $current_step->options->[$next_step_index]->target;
      push @steps, $next_step_index;
    } elsif ($_ =~ m/^step_back$/) {
      $current_step = $previous_step;
      pop @steps;
    } else {
      $c->session->{$session_key} = {} unless defined $c->session->{$session_key};
      $c->session->{$session_key}->{$_} = $c->req->param($_);
    }
  }
  $c->stash->{step_count} = scalar @steps;
  $c->stash->{steps_arg} = '-'.join('-',@steps);
  $c->stash->{steps} = \@steps;
  $c->stash->{step} = $current_step;
}

no Moose;
__PACKAGE__->meta->make_immutable;
