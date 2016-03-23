package DDGC::DB::Result::ContributorActivity;
# ABSTRACT:

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'contributor_activity';

column github_event_id          => {data_type => 'text', is_nullable => 0};
column contributor_id           => {data_type => 'bigint', is_nullable => 0};
column github_repo_id           => {data_type => 'bigint', is_nullable => 0};
column contribution_type        => {data_type => 'text', is_nullable => 0};
column contribution_date        => {data_type => 'timestamp with time zone', is_nullable => 0};

unique_constraint (qw/ github_event_id github_repo_id /);

has_one 'repo', 'DDGC::DB::Result::GitHub::Repo', 'github_repo_id';
has_one 'user', 'DDGC::DB::Result::GitHub::User', 'contributor_id';

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
