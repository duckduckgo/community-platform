package DDGC::DB::Result::Help::Category;
# ABSTRACT: Help category

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'help_category';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

unique_column key => {
  data_type => 'text',
  is_nullable => 0,
};

column sort => {
  data_type => 'int',
  is_nullable => 0,
};

column data => {
  data_type => 'text',
  is_nullable => 1,
  serializer_class => 'JSON',
};

column notes => {
  data_type => 'text',
  is_nullable => 1,
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

has_many 'help_category_contents', 'DDGC::DB::Result::Help::Category::Content', 'help_category_id';
has_many 'helps', 'DDGC::DB::Result::Help', 'help_category_id';

sub content_by_language_id {
  my ( $self, $language_id ) = @_;
  $self->search_related('help_category_contents',{
    language_id => $language_id
  })->one_row;
}

sub content_by_language_id_cached {
  my ( $self, $language_id ) = @_;
  $self->search_related('help_category_contents',{
    language_id => $language_id
  },{
    cache_for => 600
  })->one_row;
}

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
