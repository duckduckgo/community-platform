package DDGC::Web::Controller::Help;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('help') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->add_bc('Help articles', $c->chained_uri('Help','index'));
}

sub index_redirect :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri('Help','index','en_US'));
}

sub language :Chained('base') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $locale ) = @_;
  $c->stash->{help_language} = $c->d->rs('Language')->search({ locale => $locale })->first;
  if (!$c->stash->{help_language}) {
    $c->response->redirect($c->chained_uri('Help','index',{ language_notfound => 1 }));
    return $c->detach;
  }
  $c->stash->{help_language_id} = $c->stash->{help_language}->id;
}

sub index :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
  $c->stash->{help_categories} = $c->d->rs('Help::Category')->search({},{
    order_by => { -asc => 'me.sort' },
    prefetch => [ 'content', { helps => 'content' } ],
  });
}

sub category_base :Chained('language') :CaptureArgs(1) {
  my ( $self, $c, $category ) = @_;
  $c->stash->{help_category} = $c->d->rs('Help::Category')->search({ key => $category },{
    prefetch => [ 'content', { helps => 'content' } ],
  })->first;
  if (!$c->stash->{help_category}) {
    $c->response->redirect($c->chained_uri('Help','index',{ category_notfound => 1 }));
    return $c->detach;
  }
  $c->stash->{help_category_content} = $c->stash->{help_category}->content_by_language_id($c->stash->{help_language_id});
  $c->add_bc($c->stash->{help_category_content}->title, $c->chained_uri('Help','category',$c->stash->{help_category}->key));
}

sub category :Chained('category_base') :Args(0) {
  my ( $self, $c ) = @_;
}

sub help_base :Chained('category_base') :PathPart('article') :CaptureArgs(1) {
  my ( $self, $c, $key ) = @_;
	$c->stash->{help} = $c->stash->{help_category}->search_related('helps',{
    key => $key
  })->first;
	if (!$c->stash->{help}) {
		$c->response->redirect($c->chained_uri('Help','index',{ help_notfound => 1 }));
		return $c->detach;
	}
  $c->stash->{help_content} = $c->stash->{help}->search_related('help_content',{
    language_id => $c->stash->{help_language}->id
  })->first;
}

sub help :Chained('help_base') :Args(0) {
  my ( $self, $c ) = @_;
}

no Moose;
__PACKAGE__->meta->make_immutable;
