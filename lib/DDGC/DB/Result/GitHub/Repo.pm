package DDGC::DB::Result::GitHub::Repo;
# ABSTRACT:

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'github_repo';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

unique_column github_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column github_user_id => {
  data_type => 'bigint',
  is_nullable => 0,
};
belongs_to 'github_user', 'DDGC::DB::Result::GitHub::User', 'github_user_id', {
  on_delete => 'cascade',
};

column full_name => {
  data_type => 'text',
  is_nullable => 0,
};
sub owner_name { my @p = split('/',$_[0]->full_name); return $p[0]; }
sub repo_name { my @p = split('/',$_[0]->full_name); return $p[1]; }

column description => {
  data_type => 'text',
  is_nullable => 0,
};

column pushed_at => {
  data_type => 'timestamp with time zone',
  is_nullable => 0,
};

column open_issues_count => {
  data_type => 'int',
  is_nullable => 0,
};

column watchers_count => {
  data_type => 'int',
  is_nullable => 0,
};

column forks_count => {
  data_type => 'int',
  is_nullable => 0,
};

column company_repo => {
  data_type => 'int',
  is_nullable => 0,
  default_value => 0,
};

column created_at => {
  data_type => 'timestamp with time zone',
  is_nullable => 0,
};

column updated_at => {
  data_type => 'timestamp with time zone',
  is_nullable => 1,
};

column pushed_at => {
  data_type => 'timestamp with time zone',
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

column gh_data => {
  data_type => 'text',
  is_nullable => 0,
  serializer_class => 'AnyJSON',
  default_value => '{}',
};

has_many 'github_commits', 'DDGC::DB::Result::GitHub::Commit', 'github_repo_id', {
  cascade_delete => 1,
};

has_many 'github_pulls', 'DDGC::DB::Result::GitHub::Pull', 'github_repo_id', {
  cascade_delete => 1,
};

has_many 'github_issues', 'DDGC::DB::Result::GitHub::Issue', 'github_issue_id', {
  cascade_delete => 1,
};

no Moose;
__PACKAGE__->meta->make_immutable;
