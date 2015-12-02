package DDGC::Web::Controller::Duckduckhack;
# ABSTRACT: DuckDuckHack web controller class

use Moose;
use namespace::autoclean;
use Web::Scraper;
use File::Spec;
use IO::All -utf8;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('duckduckhack') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->stash->{duckduckhack} = 1;
  $c->stash->{no_breadcrumb} = 1;
  $c->stash->{title} = 'DuckDuckHack Documentation';
  $c->stash->{page_class} = "duckduckhack-docs";
}

sub index :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->response->redirect($c->chained_uri('Duckduckhack','doc','ddh-intro'));
  return $c->detach;
}

sub doc :Chained('base') :PathPart('') :Args(1) {
  my ( $self, $c, $doc ) = @_;
  eval {
    my ( $title, $content ) = @{$self->fetch_doc($c,$doc)};
    $c->stash->{doc} = $content;
    $c->stash->{title} = $title;
  };
  if ($@) {
    $c->response->redirect($c->chained_uri('Duckduckhack','doc','ddh-intro',{
      error => $@,
    }));
    return $c->detach;
  }
}

sub fetch_doc {
  my ( $self, $c, $doc ) = @_;

  $c->response->redirect($c->chained_uri('Duckduckhack','doc','ddh-intro'))
    if ( $doc =~ /[^[:alnum:]_-]/ );

  my $file = File::Spec->catfile( $c->d->config->docsdir, $doc );

  return $c->d->cache->get($file) if defined $c->d->cache->get($file);

  my $content;
  my $title;

  if ( -f $file ) {
    my $html_content = io->file($file)->slurp;
    my $scraper = scraper {
      process "#duckduckhack-body", doc => "HTML";
      process "title", title => "TEXT";
    };
    my $res = $scraper->scrape($html_content);
    $content = $res->{doc};
    $title = $res->{title};
  }

  unless ($content) {
    if ($c->d->cache->get('permcache:'.$file)) {
      ( $title, $content ) = @{$c->d->cache->get('permcache:'.$file)};
      $c->d->cache->set($file,[$title,$content],"5 minutes");
      return $content;
    } else {
      die "can't fetch documentation";
    }
  }

  $c->d->cache->set($file,[$title,$content],"15 minutes");
  $c->d->cache->set('permcache:'.$file,[$title,$content]);

  return [$title,$content];
}

no Moose;
__PACKAGE__->meta->make_immutable;
