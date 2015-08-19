package DDGC::DB::Result::Help::Category::Content;
# ABSTRACT: Help category language specific content

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'help_category_content';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column help_category_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

belongs_to 'help_category', 'DDGC::DB::Result::Help::Category', 'help_category_id', {
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

column description => {
  data_type => 'text',
  is_nullable => 0,
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

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
