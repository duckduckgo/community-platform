package DDGC::Web::Controller::Help;
# ABSTRACT:

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('help') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->stash->{page_class} = "page-help  texture-ducksymbol";
  $c->stash->{help_categories} = $c->d->rs('Help::Category')->search({},{
    order_by => { -asc => 'me.sort' },
    prefetch => [ 'help_category_contents', { helps => 'help_contents' } ],
    cache_for => 600,
  });
  $c->stash->{title} = 'Help pages';
  $c->stash->{help_language} = $c->d->rs('Language')->search({ locale => 'en_US' })->first;
  $c->stash->{help_language_id} = $c->stash->{help_language}->id;
}

sub legacy_redirect :Chained('base') :PathPart('en_US') :Args {
  my ( $self, $c, @args ) = @_;
  $c->response->redirect('https://duck.co/help/'.join('/',@args));
}

# sub language :Chained('base') :PathPart('') :CaptureArgs(1) {
#   my ( $self, $c, $locale ) = @_;
#   my $oldurl_help = $c->d->rs('Help')->search({
#     old_url => { -like => 'http://help.dukgo.com/customer/portal/articles/'.$locale.'%' }
#   },{
#     cache_for => 86400,
#   })->first;
#   if ($oldurl_help) {
#     $c->response->redirect($c->chained_uri('Help','help','en_US',$oldurl_help->help_category->key,$oldurl_help->key));
#     return $c->detach;
#   }
#   unless ($locale eq 'en_US') {
#     $c->response->redirect($c->chained_uri('Root','index',{ help_language_notfound => 1 }));
#     return $c->detach;
#   }
#   $c->stash->{help_language} = $c->d->rs('Language')->search({ locale => $locale })->first;
#   if (!$c->stash->{help_language}) {
#     $c->response->redirect($c->chained_uri('Root','index',{ help_language_notfound => 1 }));
#     return $c->detach;
#   }
#   $c->add_bc('Help articles', $c->chained_uri('Help','index',$locale));
#   $c->stash->{help_language_id} = $c->stash->{help_language}->id;
# }

sub index :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
}

sub search :Chained('base') :Args(0) {
  my ( $self, $c ) = @_;
  $c->add_bc('Search');
  $c->stash->{help_search} = $c->req->param('help_search');
  return unless $c->stash->{help_search};

  my $result = $c->d->help->search(q => $c->stash->{help_search});

  my %articles;
  my $articles_rs;
  my $case = "CASE id";

  if ($result && $result->total) {
      if (my $ducky = $c->req->param('ducky')) {
          my @uri = split '/', $result->results->[0]->uri;
          $c->response->redirect(join '/', @uri[1,2]);
          return $c->detach;
      }

      my @ids;
      push @ids, $_->get_field('id')->[0] for @{$result->results};

      $articles{$_->get_field('id')->[0]} = $_ for @{$result->results};
      my $i;

      $case .= ' WHEN '.$_.' THEN '.++$i for @ids;
      $case .= ' ELSE '.++$i.' END, id';
      
      $articles_rs = $c->d->rs('Help')->search_rs({id => \@ids},
          { order_by => {
                -desc =>
                    \do { $case }
              }
      });
  }

  $c->stash->{articles} = \%articles;
  $c->stash->{search_helps} = $articles_rs;
  $c->stash->{title} = 'Search help pages';
}

sub category_base :Chained('base') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $category ) = @_;
  my $oldurl_help = $c->d->rs('Help')->search({
    old_url => { -like => 'http://help.dukgo.com/customer/portal/articles/'.$category.'%' }
  },{
    cache_for => 86400,
  })->first;
  if ($oldurl_help) {
    $c->response->redirect($c->chained_uri('Help','help','en_US',$oldurl_help->help_category->key,$oldurl_help->key));
    return $c->detach;
  }
  $c->stash->{help_category} = $c->d->rs('Help::Category')->search({ 'me.key' => $category },{
    prefetch => [ 'help_category_contents', { helps => 'help_contents' } ],
    order_by => { -asc => 'helps.sort' },
    cache_for => 600,
  })->first;
  if (!$c->stash->{help_category}) {
    $c->response->redirect($c->chained_uri('Help','index',{ category_notfound => 1 }));
    return $c->detach;
  }
  $c->stash->{help_category_content} = $c->stash->{help_category}->content_by_language_id_cached($c->stash->{help_language_id});
  $c->add_bc($c->stash->{help_category_content}->title, $c->chained_uri('Help','category',$c->stash->{help_category}->key));
  $c->stash->{title} = $c->stash->{help_category_content}->title;
}

sub category :Chained('category_base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
}

sub help_base :Chained('category_base') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $key ) = @_;
	$c->stash->{help} = $c->stash->{help_category}->search_related('helps',{
    'me.key' => $key,
  },{
    order_by => { -asc => 'me.sort' },
    cache_for => 600,
  })->first;
	if (!$c->stash->{help}) {
		$c->response->redirect($c->chained_uri('Help','index',{ help_notfound => 1 }));
		return $c->detach;
	}
  $c->stash->{help_content} = $c->stash->{help}->search_related('help_contents',{
    language_id => $c->stash->{help_language}->id
  },{
    cache_for => 600,
  })->first;
  $c->add_bc($c->stash->{help_content}->title, $c->chained_uri('Help','help',$c->stash->{help_category}->key,$c->stash->{help}->key));
  $c->stash->{title} = $c->stash->{help_content}->title;
}

sub help :Chained('help_base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
}

no Moose;
__PACKAGE__->meta->make_immutable;
