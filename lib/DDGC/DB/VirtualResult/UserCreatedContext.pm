package DDGC::DB::VirtualResult::UserCreatedContext;
# ABSTRACT: 

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;

table 'usercreatedcontext';

column amount => {
  data_type => 'int',
  is_nullable => 0,
};

column tableclass => {
  data_type => 'text',
  is_nullable => 0,
};

column context => {
  data_type => 'text',
  is_nullable => 1,
};

column users_id => {
  data_type => 'bigint',
  is_nullable => 1,
};
belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', {
  on_delete => 'no action',
};

no Moose;
__PACKAGE__->meta->make_immutable;
