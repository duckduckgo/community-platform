package DDGC::DB::Result::Screenshot;
# ABSTRACT: Screenshot

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;

use DDGC::Web::Form::Maker;
with qw( DDGC::Web::Role::Formable );

use namespace::autoclean;

table 'screenshot';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';
f_hidden 'id';

column user_agent => {
  data_type => 'text',
  is_nullable => 1,
};
f_text 'user_agent', label => "User agent used";

column url => {
  data_type => 'text',
  is_nullable => 1,
};
f_text 'url', label => "URL", notempty => 1;

column description => {
  data_type => 'text',
  is_nullable => 1,
};
f_textarea 'description', label => "Description";

column media_id => {
  data_type => 'bigint',
  is_nullable => 1,
};
#f_upload 'media', label => "Screenshot upload";

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

1;
# no Moose;
# __PACKAGE__->meta->make_immutable;
