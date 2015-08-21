package DDGC::DB::VirtualResult::UserContentRelation;
# ABSTRACT: 

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;

table 'virtual_UserContentRelation';

column amount => {
  data_type => 'int',
  is_nullable => 0,
};

column resultset => {
  data_type => 'text',
  is_nullable => 0,
};

column scope => {
  data_type => 'text',
  is_nullable => 1,
};

column relation => {
  data_type => 'text',
  is_nullable => 0,
};

column users_id => {
  data_type => 'bigint',
  is_nullable => 1,
};
belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', {
  on_delete => 'no action', join_type => 'left',
};

column other_user_entity => {
  data_type => 'text',
  is_nullable => 1,
};

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
