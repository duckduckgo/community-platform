package DDGC::DB::Result::Screenshot;
# ABSTRACT: Screenshot

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'screenshot';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column url => {
  data_type => 'text',
  is_nullable => 1,
};

column description => {
  data_type => 'text',
  is_nullable => 1,
};

column media_id => {
  data_type => 'bigint',
  is_nullable => 1,
};

column data => {
  data_type => 'text',
  is_nullable => 1,
  serializer_class => 'JSON',
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

belongs_to 'media', 'DDGC::DB::Result::Media', 'media_id', {
  on_delete => 'cascade',
};

has_many 'screenshot_threads', 'DDGC::DB::Result::Screenshot::Thread', 'screenshot_id';
has_many 'screenshot_tokens', 'DDGC::DB::Result::Screenshot::Token', 'screenshot_id';

1;
# no Moose;
# __PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
