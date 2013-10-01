package DDGC::Web::Controller::Duckduckhack;
# ABSTRACT: DuckDuckHack web controller class

use Moose;
use namespace::autoclean;
use Web::Scraper;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('duckduckhack') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->stash->{no_breadcrumb} = 1;
}

sub index :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri('Duckduckhack','doc','ddh-intro'));
  return $c->detach;
}

sub doc :Chained('base') :PathPart('') :Args(1) {
  my ( $self, $c, $doc ) = @_;
  $c->stash->{doc} = $self->fetch_doc($c,$doc);
}

sub fetch_doc {
  my ( $self, $c, $doc ) = @_;
  my $url = $c->d->config->duckduckhack_url.'/'.$doc;

  return $c->d->cache->get($url) if defined $c->d->cache->get($url);

  my $response = $c->d->http->get($url);

  my $content;

  if ($response->is_success) {
    my $http_content = $response->decoded_content;
    my $scraper = scraper {
      process "#duckduckhack-body", doc => "HTML";
    };
    my $res = $scraper->scrape($http_content);
    $content = $res->{doc};
  }

  unless ($content) {
    if ($content = $c->d->cache->get('permcache:'.$url)) {
      $c->d->cache->set($url,$content,"5 minutes");
      return $content;
    } else {
      die "can't fetch documentation";
    }
  }

  $c->d->cache->set($url,$content,"1 hour");
  $c->d->cache->set('permcache:'.$url,$content);

  return $content;
}

no Moose;
__PACKAGE__->meta->make_immutable;
