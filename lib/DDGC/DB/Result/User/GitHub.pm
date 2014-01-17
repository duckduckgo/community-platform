package DDGC::DB::Result::User::GitHub;
# ABSTRACT: GitHub Account link to user account

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'user_github';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
  data_type => 'bigint',
  is_nullable => 1,
};

column token => {
  data_type => 'text',
  is_nullable => 0,
};

column github_user_id => {
  data_type => 'bigint',
  is_nullable => 1,
};
belongs_to 'github_user', 'DDGC::DB::Result::GitHub::User', 'github_user_id', {
  on_delete => 'cascade', join_type => 'left',
};

column scopes => {
  data_type => 'text',
  is_nullable => 0,
  serializer_class => 'JSON',
  default_value => '[]',
};

column data => {
  data_type => 'text',
  is_nullable => 0,
  serializer_class => 'JSON',
  default_value => '{}',
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

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', {
  on_delete => 'no action',
};

###############################

no Moose;
__PACKAGE__->meta->make_immutable;

1;
