package DDGC::Web::Controller::Feedback;
use Moose;
use DDGC::Feedback::Step;
use DDGC::Feedback::Config;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('feedback') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->add_bc('Feedback');
}

sub thanks :Chained('base') :Args(0) {}

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
  my $session_key = $c->stash->{feedback_name}.'/'.join('-',@steps);
  my $submit;
  for (keys %{$c->req->params}) {
    if ($_ =~ m/^option_(\d+)$/) {
      my $next_step_index = $1;
      $previous_step = $current_step;
      my $next_option = $current_step->options->[$next_step_index];
      if ($next_option->type eq 'submit') {
        $submit = 1;
      } else {
        $current_step = $next_option->target;
        push @steps, $next_step_index;
      }
    } elsif ($_ =~ m/^step_back$/) {
      $current_step = $previous_step;
      pop @steps;
    } else {
      $c->session->{feedback} = {} unless defined $c->session->{feedback};
      $c->session->{feedback}->{$session_key} = {} unless defined $c->session->{feedback}->{$session_key};
      $c->session->{feedback}->{$session_key}->{$_} = $c->req->param($_);
    }
  }
  $c->stash->{step_count} = scalar @steps;
  $c->stash->{steps_arg} = '-'.join('-',@steps);
  $c->stash->{steps} = \@steps;
  $c->stash->{step} = $current_step;
  if ($submit) {
    my %data;
    my $data_step = $c->stash->{feedback};

    my @data_steps;
    my $i = 1;
    for (@steps) {
      push @data_steps, $_;
      my $step_session_key = $c->stash->{feedback_name}.'/'.join('-',@data_steps);
      if (defined $c->session->{feedback}->{$step_session_key}) {
        my %step_data = %{$c->session->{feedback}->{$step_session_key}};
        for (keys %step_data) {
          my $data_key = $i.'_'.$_;
          $data{$data_key} = $step_data{$_};
        }
      }
      my $next_option = $data_step->options->[$_];
      $data{$i} = $next_option->description;
      $i++;
      if ($next_option->type eq 'submit') {
        last;
      } else {
        $data_step = $next_option->target;
      }
    }

    $c->stash->{feedback_data} = \%data;
    my @header_field_names = $c->req->headers->header_field_names();
    $c->stash->{header_field_names} = [grep { $_ ne 'COOKIE' } @header_field_names];

    $c->stash->{email} = {
      to          => 'communitytest@duckduckgo.com',
      from        => 'noreply@dukgo.com',
      subject     => '[DDG Feedback '.$c->stash->{feedback_name}.'] '.$data{'1'},
      template        => 'email/feedback.tx',
      charset         => 'utf-8',
      content_type => 'text/html',
    };

    $c->forward( $c->view('Email::Xslate') );

    delete $c->session->{feedback};

    $c->res->redirect($c->chained_uri('Feedback','thanks'));
    return $c->detach;
  }
}



no Moose;
__PACKAGE__->meta->make_immutable;
