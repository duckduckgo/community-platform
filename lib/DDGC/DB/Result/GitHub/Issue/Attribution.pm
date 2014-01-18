package DDGC::DB::Result::GitHub::Issue::Attribution;
# ABSTRACT:

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'github_issue_attribution';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

unique_column github_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column users_id => {
  data_type => 'bigint',
  is_nullable => 0,
};
belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', {
  on_delete => 'no action',
};

column reason => {
  data_type => 'text',
  is_nullable => 0,
};

column approved_by_admin => {
  data_type => 'int',
  is_nullable => 0,
  default_value => 0,
};

column github_issue_id => {
  data_type => 'bigint',
  is_nullable => 0,
};
belongs_to 'github_issue', 'DDGC::DB::Result::GitHub::Issue', 'github_issue_id', {
  on_delete => 'cascade',
};

column created => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
};

no Moose;
__PACKAGE__->meta->make_immutable;
