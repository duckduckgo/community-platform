package DDGC::Web::Controller::Help;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('help') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
}

sub category :Chained('base') :Args(1) {
  my ( $self, $c, $category ) = @_;
}

sub help :Chained('base') :PathPart('article') :CaptureArgs(1) {
  my ( $self, $c, $key ) = @_;
	$c->stash->{help} = $c->d->rs('Help')->search({ key => $key })->first;
	if (!$c->stash->{help}) {
		$c->response->redirect($c->chained_uri('Help','index',{ help_notfound => 1 }));
		return $c->detach;
	}
}

sub help_redirect :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri('Help','view',$c->stash->{help}->key,'en_US'));
  return $c->detach;
}

sub language :Chained('help') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $locale ) = @_;
  $c->stash->{help_language} = $c->d->rs('Language')->search({ locale => $locale })->first;
  if (!$c->stash->{help_language}) {
    $c->response->redirect($c->chained_uri('Help','index',{ language_notfound => 1 }));
    return $c->detach;
  }
  $c->stash->{help_content} = $c->stash->{help}->search_related('help_content',{
    language_id => $c->stash->{help_language}->id
  })->first;
  if (!$c->stash->{help_content}) {
    $c->response->redirect($c->chained_uri('Help','index',{ help_content_notfound => 1 }));
    return $c->detach;
  }
}

sub view :Chained('language') :Args(0) {
  my ( $self, $c ) = @_;
}

no Moose;
__PACKAGE__->meta->make_immutable;
