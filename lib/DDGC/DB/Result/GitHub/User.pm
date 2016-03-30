package DDGC::DB::Result::GitHub::User;
# ABSTRACT:

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'github_user';

primary_column id             => {data_type => 'bigint', is_auto_increment => 1};
unique_column github_id       => {data_type => 'bigint', is_nullable       => 0};
column login                  => {data_type => 'text',   is_nullable       => 0};
column gravatar_id            => {data_type => 'text',   is_nullable       => 1};
column name                   => {data_type => 'text',   is_nullable       => 1};
column company                => {data_type => 'text',   is_nullable       => 1};
column blog                   => {data_type => 'text',   is_nullable       => 1};
column location               => {data_type => 'text',   is_nullable       => 1};
column email                  => {data_type => 'text',   is_nullable       => 1};
column bio                    => {data_type => 'text',   is_nullable       => 1};
column type                   => {data_type => 'text',   is_nullable       => 0};
column created_at             => {data_type => 'timestamp with time zone', is_nullable => 0};
column updated_at             => {data_type => 'timestamp with time zone', is_nullable => 1};
column isa_owners_team_member => {data_type => 'int',    is_nullable       => 0, default_value => 0};
column scope_public_repo      => {data_type => 'int',    is_nullable       => 0, default_value => 0};
column scope_user_email       => {data_type => 'int',    is_nullable       => 0, default_value => 0};
column created                => {data_type => 'timestamp with time zone', set_on_create  => 1};
column updated                => {data_type => 'timestamp with time zone', set_on_create  => 1, set_on_update => 1};
column gh_data                => {
    data_type          => 'text',
    is_nullable        => 0,
    serializer_class   => 'JSON',
    serializer_options => { convert_blessed => 1, pretty => 1 },
};

belongs_to user => 'DDGC::DB::Result::User',
    { 'foreign.github_id' => 'self.github_id' },
    { on_delete => 'no action', join_type => 'left' };

has_many github_commits_authored => 'DDGC::DB::Result::GitHub::Commit',
    { 'foreign.github_user_id_author' => 'self.id' },
    { cascade_delete => 1 };

has_many github_commits_committed => 'DDGC::DB::Result::GitHub::Commit',
    { 'foreign.github_user_id_committer' => 'self.id' },
    { cascade_delete => 1 };

has_many github_pulls => 'DDGC::DB::Result::GitHub::Pull',
    { 'foreign.github_user_id' => 'self.id' },
    { cascade_delete => 1 };

has_many github_repos => 'DDGC::DB::Result::GitHub::Repo',
    { 'foreign.github_user_id' => 'self.id' },
    { cascade_delete => 1 };

has_many github_issues => 'DDGC::DB::Result::GitHub::Issue',
    { 'foreign.github_user_id' => 'self.id' },
    { cascade_delete => 1 };

has_many github_issue_events => 'DDGC::DB::Result::GitHub::Issue::Event',
    { 'foreign.github_user_id' => 'self.id' },
    { cascade_delete => 1 };

has_many github_commit_comments => 'DDGC::DB::Result::GitHub::CommitComments',
    { 'foreign.github_user_id' => 'self.id' },
    { cascade_delete => 1 };

has_many contributor_activity => 'DDGC::DB::Result::ContributorActivity',
    { 'foreign.contributor_id' => 'self.id' },
    { cascade_delete => 0 };

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
