package DDGC::Web::Controller::Goodies;
# ABSTRACT:

use Moose;
use namespace::autoclean;

use DDGC::Config;
use Dist::Data;
use Path::Class;
use Pod::Simple::XHTML;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('goodies') :CaptureArgs(0) {
  my ( $self, $c ) = @_;
  $c->stash->{title} = 'DuckDuckGo Goodies';
  $c->add_bc('DuckDuckGo Goodies', $c->chained_uri('Goodies','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
  my ( $self, $c ) = @_;
  $c->bc_index;
}

my %base_types = (
  spice => [qw( Spices )],
  goodie => [qw( Goodies )],
  longtail => [qw( Longtail )],
  fathead => [qw( Fathead )],
);

sub list :Chained('base') :PathPart('') :Args(1) {
  my ( $self, $c, $type ) = @_;
  if (grep { $_ eq $type } keys %base_types) {
    my ( $desc ) = @{$base_types{$type}};
    $c->stash->{title} = 'DuckDuckGo '.$desc;
    $c->add_bc($desc, $c->chained_uri('Goodies','list',$type));
    $c->stash->{goodies_type} = $type;
    $c->stash->{goodies_desc} = $desc;
    $c->stash->{goodies} = $c->d->rs('DuckPAN::Goodie')->search_rs({
      'me.name' => { -like => 'DDG::'.ucfirst($type).'::%' },
    },{
      order_by => { -desc => 'me.updated' },
    });
  }
}

sub goodie_arga :Chained('base') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $arg ) = @_;
  $c->stash->{arga} = $arg;
}

sub goodie_argb :Chained('goodie_arga') :PathPart('') :CaptureArgs(1) {
  my ( $self, $c, $arg ) = @_;
  $c->stash->{argb} = $arg;
}

sub goodie :Chained('goodie_argb') :PathPart('') :Args {
  my ( $self, $c, @args ) = @_;
  my @name_parts = ( $c->stash->{arga}, $c->stash->{argb}, @args );
  $c->stash->{goodie} = $c->d->rs('DuckPAN::Goodie')->search_rs(\[
    'LOWER(me.name) LIKE ?',[ plain_value => lc('ddg::'.join('::',@name_parts)) ]
  ])->first;
  unless ($c->stash->{goodie}) {
    $c->response->redirect($c->chained_uri('Goodies','index',{ goodie_notfound => 1 }));
    return $c->detach;
  }
  $c->stash->{title} = $c->stash->{goodie}->duckpan_meta->{ddg_meta}->{name};
  $c->add_bc($c->stash->{goodie}->duckpan_meta->{ddg_meta}->{name});
}

__PACKAGE__->meta->make_immutable;
1;
