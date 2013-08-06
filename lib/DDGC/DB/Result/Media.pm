package DDGC::DB::Result::Media;
# ABSTRACT: Media meta data

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'media';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column filename => {
  data_type => 'text',
  is_nullable => 0,
};

column upload_filename => {
  data_type => 'text',
  is_nullable => 1,
};

column source_url => {
  data_type => 'text',
  is_nullable => 1,
};

column content_type => {
  data_type => 'text',
  is_nullable => 1,
};

column title => {
  data_type => 'text',
  is_nullable => 1,
};

column description => {
  data_type => 'text',
  is_nullable => 1,
};

column users_id => {
  data_type => 'bigint',
  is_nullable => 0,
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

unique_constraint [qw/ users_id filename /];

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', { join_type => 'left' };

no Moose;
__PACKAGE__->meta->make_immutable;
