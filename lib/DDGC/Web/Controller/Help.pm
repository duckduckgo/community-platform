package DDGC::Web::Controller::Help;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('help') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->stash->{page_class} = "page-help  texture-ducksymbol";
  $c->stash->{help_categories} = $c->d->rs('Help::Category')->search({},{
    order_by => { -asc => 'me.sort' },
    prefetch => [ 'help_category_contents', { helps => 'help_contents' } ],
  });
  $c->stash->{title} = 'Help pages';
}

sub index_redirect :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri('Help','index','en_US'));
}

sub language :Chained('base') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $locale ) = @_;
  my $oldurl_help = $c->d->rs('Help')->search({ old_url => { -like => 'http://help.dukgo.com/customer/portal/articles/'.$locale.'%' }})->first;
  if ($oldurl_help) {
    $c->response->redirect($c->chained_uri('Help','help','en_US',$oldurl_help->help_category->key,$oldurl_help->key));
    return $c->detach;
  }
  unless ($locale eq 'en_US') {
    $c->response->redirect($c->chained_uri('Root','index',{ help_language_notfound => 1 }));
    return $c->detach;
  }
  $c->stash->{help_language} = $c->d->rs('Language')->search({ locale => $locale })->first;
  if (!$c->stash->{help_language}) {
    $c->response->redirect($c->chained_uri('Root','index',{ help_language_notfound => 1 }));
    return $c->detach;
  }
  $c->add_bc('Help articles', $c->chained_uri('Help','index',$locale));
  $c->stash->{help_language_id} = $c->stash->{help_language}->id;
}

sub index :Chained('language') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
}

sub search :Chained('language') :Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc('Search');
  $c->stash->{help_search} = $c->req->param('help_search');
  return unless $c->stash->{help_search};
  $c->stash->{search_helps} = $c->d->rs('Help')->search({
    content => { -like => '%'.$c->stash->{help_search}.'%' },
  },{
    order_by => { -asc => 'me.sort' },
    prefetch => [ 'help_contents', { help_category => 'help_category_contents' } ],
  });
  $c->stash->{title} = 'Search help pages';
}

sub category_base :Chained('language') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $category ) = @_;
  $c->stash->{help_category} = $c->d->rs('Help::Category')->search({ 'me.key' => $category },{
    prefetch => [ 'help_category_contents', { helps => 'help_contents' } ],
    order_by => { -asc => 'helps.sort' },
  })->first;
  if (!$c->stash->{help_category}) {
    $c->response->redirect($c->chained_uri('Help','index',$c->stash->{help_language}->locale,{ category_notfound => 1 }));
    return $c->detach;
  }
  $c->stash->{help_category_content} = $c->stash->{help_category}->content_by_language_id($c->stash->{help_language_id});
  $c->add_bc($c->stash->{help_category_content}->title, $c->chained_uri('Help','category',$c->stash->{help_language}->locale,$c->stash->{help_category}->key));
  $c->stash->{title} = $c->stash->{help_category_content}->title;
}

sub category :Chained('category_base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
}

sub help_base :Chained('category_base') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $key ) = @_;
	$c->stash->{help} = $c->stash->{help_category}->search_related('helps',{
    'me.key' => $key
  },{
    order_by => { -asc => 'me.sort' },
  })->first;
	if (!$c->stash->{help}) {
		$c->response->redirect($c->chained_uri('Help','index',$c->stash->{help_language}->locale,{ help_notfound => 1 }));
		return $c->detach;
	}
  $c->stash->{help_content} = $c->stash->{help}->search_related('help_contents',{
    language_id => $c->stash->{help_language}->id
  })->first;
  $c->add_bc($c->stash->{help_content}->title, $c->chained_uri('Help','help',$c->stash->{help_language}->locale,$c->stash->{help_category}->key,$c->stash->{help}->key));
  $c->stash->{title} = $c->stash->{help_content}->title;
}

sub help :Chained('help_base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
}

no Moose;
__PACKAGE__->meta->make_immutable;
