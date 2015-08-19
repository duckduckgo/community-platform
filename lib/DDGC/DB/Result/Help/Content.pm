package DDGC::DB::Result::Help::Content;
# ABSTRACT: Help category

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'help_content';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column help_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

belongs_to 'help', 'DDGC::DB::Result::Help', 'help_id', {
  on_delete => 'no action',
};

column language_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

belongs_to 'language', 'DDGC::DB::Result::Language', 'language_id', {
  on_delete => 'no action',
};

column title => {
  data_type => 'text',
  is_nullable => 0,
};

column teaser => {
  data_type => 'text',
  is_nullable => 0,
};

column content => {
  data_type => 'text',
  is_nullable => 0,
};

column raw_html => {
  data_type => 'int',
  is_nullable => 0,
  default => 0,
};

column created => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
};

column updated => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
  set_on_update => 1,
};

sub content_html {
  my ( $self ) = @_;
  if ($self->raw_html) {
    return $self->content;
  } else {
    return $self->ddgc->markup->html($self->content);
  }
}

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
