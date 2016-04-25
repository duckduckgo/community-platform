package DDGC::DB::Result::ContributorGithubActivity;
# ABSTRACT:

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'contributor_github_activity';

primary_column github_event_github_id  => {data_type => 'text', is_nullable => 0};
column github_user_github_id           => {data_type => 'bigint', is_nullable => 0};
primary_column github_repo_github_id   => {data_type => 'bigint', is_nullable => 0};
column contribution_type               => {data_type => 'text', is_nullable => 0};
column contribution_date               => {data_type => 'timestamp with time zone', is_nullable => 0};

unique_constraint [qw( github_event_github_id github_repo_github_id)];

belongs_to 'repo', 'DDGC::DB::Result::GitHub::Repo', 'github_repo_github_id';
belongs_to 'user', 'DDGC::DB::Result::GitHub::User', 'github_user_github_id';

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
