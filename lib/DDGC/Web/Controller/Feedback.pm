package DDGC::Web::Controller::Feedback;
# ABSTRACT:

use Moose;
use DDGC::Feedback::Step;

use DDGC::Feedback::Config::Bug;
use DDGC::Feedback::Config::Relevancy;
use DDGC::Feedback::Config::Bang;
use DDGC::Feedback::Config::Feature;
use DDGC::Feedback::Config::Love;
use DDGC::Feedback::Config::NoLove;
use DDGC::Feedback::Config::Suggest;
use DDGC::Feedback::Config::Partner;


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
  if ($feedback eq 'bug') {
    $c->stash->{feedback_config} = DDGC::Feedback::Config::Bug->feedback;
    $c->stash->{feedback_title} = DDGC::Feedback::Config::Bug->feedback_title;
  } elsif ($feedback eq 'partner') {
    $c->stash->{feedback_config} = DDGC::Feedback::Config::Partner->feedback;
    $c->stash->{feedback_title} = DDGC::Feedback::Config::Partner->feedback_title;
  } elsif ($feedback eq 'relevancy') {
    $c->stash->{feedback_config} = DDGC::Feedback::Config::Relevancy->feedback;
    $c->stash->{feedback_title} = DDGC::Feedback::Config::Relevancy->feedback_title;
  } elsif ($feedback eq 'bang') {
    $c->stash->{feedback_config} = DDGC::Feedback::Config::Bang->feedback;
    $c->stash->{feedback_title} = DDGC::Feedback::Config::Bang->feedback_title;
  } elsif ($feedback eq 'feature') {
    $c->stash->{feedback_config} = DDGC::Feedback::Config::Feature->feedback;
    $c->stash->{feedback_title} = DDGC::Feedback::Config::Feature->feedback_title;
  } elsif ($feedback eq 'love') {
    $c->stash->{feedback_config} = DDGC::Feedback::Config::Love->feedback;
    $c->stash->{feedback_title} = DDGC::Feedback::Config::Love->feedback_title;
  } elsif ($feedback eq 'nolove') {
    $c->stash->{feedback_config} = DDGC::Feedback::Config::NoLove->feedback;
    $c->stash->{feedback_title} = DDGC::Feedback::Config::NoLove->feedback_title;
  } elsif ($feedback eq 'suggest') {
    $c->response->status(404);
    $c->response->redirect('/');
    return $c->detach;
    if (!$c->user) {
      $c->response->redirect($c->chained_uri('My','login'));
      return $c->detach;
    }
    $c->stash->{feedback_config} = DDGC::Feedback::Config::Suggest->feedback;
    @{$c->stash->{feedback_config}} = grep {
      ((!$_) || (!$_->{user_filter}) || $_->{user_filter}->($c->user))
    } @{$c->stash->{feedback_config}};
    $c->stash->{feedback_title} = DDGC::Feedback::Config::Suggest->feedback_title;
  } else {
    $c->response->redirect('https://duckduckgo.com/feedback');
    return $c->detach;
  }
  $c->stash->{feedback} = DDGC::Feedback::Step->new_from_config(@{$c->stash->{feedback_config}});
  $c->stash->{title} = $c->stash->{feedback_title};
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
  my $next_step_index;
  for (keys %{$c->req->params}) {
    if ($_ =~ m/^option_(\d+)$/) {
      $next_step_index = $1;
    } elsif ($_ =~ m/^step_back$/) {
      $current_step = $previous_step;
      pop @steps;
    } else {
      $c->session->{feedback} = {} unless defined $c->session->{feedback};
      $c->session->{feedback}->{$session_key} = {} unless defined $c->session->{feedback}->{$session_key};
      $c->session->{feedback}->{$session_key}->{$_} = $c->req->param($_);
    }
  }
  if (defined $next_step_index) {
    my $missing;
    for (@{$current_step->options}) {
      next unless $_->type eq 'text' || $_->type eq 'textarea';
      if ($_->required && !$c->req->param($_->name)) {
        $_->missing(1); $missing = 1;
      }
    }
    unless ($missing) {
      $previous_step = $current_step;
      my $next_option = $current_step->options->[$next_step_index];
      if ($next_option->type eq 'submit') {
        $submit = 1;
      } else {
        $current_step = $next_option->target;
        push @steps, $next_step_index;
      }
      $session_key = $c->stash->{feedback_name}.'/'.join('-',@steps);
    }
  }
  if ($current_step->has_options) {
    for (@{$current_step->options}) {
      my $name = $_->name;
      next unless $name;
      my $value = $c->req->param($name) || $c->session->{feedback}->{$session_key}->{$name};
      $_->value($value) if $value;
    }
  }
  $c->stash->{step_count} = scalar @steps;
  $c->stash->{steps_arg} = '-'.join('-',@steps);
  $c->stash->{steps} = \@steps;
  $c->stash->{step} = $current_step;
  if ($submit) {
    my $step_session_key_base = $c->stash->{feedback_name}.'/';
    my %data = defined $c->session->{feedback}->{$step_session_key_base}
      ? %{$c->session->{feedback}->{$step_session_key_base}}
      : ();
    my $data_step = $c->stash->{feedback};
    my @data_steps;
    my $i = 1;
    for (@steps) {
      push @data_steps, $_;
      my $step_session_key = $step_session_key_base.join('-',@data_steps);
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

    for (keys %data) {
      delete $data{$_} unless $data{$_};
    }

    $c->stash->{feedback_data} = \%data;
    my @header_field_names = $c->req->headers->header_field_names();
    $c->stash->{header_field_names} = [grep { ($_ ne 'COOKIE' && $_ ne 'User-Agent')  } @header_field_names];

    $c->stash->{c} = $c;
    $c->d->postman->template_mail(
      1,
      $c->d->config->feedback_email,
      '"DuckDuckGo Community" <noreply@duckduckgo.com>',
      '[DDG Feedback '.$c->stash->{feedback_name}.'] '.$data{'1'},
      'feedback',
      $c->stash,
      ( map {
        my $key = $_;
        my $val = $data{$key};
        $val =~ s/\R/|/g;
        'X-Feedback-'.ucfirst($_) => $val
      } keys %data ),
      'X-End' => '1',
    );

    delete $c->session->{feedback};

    $c->res->redirect($c->chained_uri('Feedback','thanks'));
    return $c->detach;
  }
}



no Moose;
__PACKAGE__->meta->make_immutable;
