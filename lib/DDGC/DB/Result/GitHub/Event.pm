package DDGC::DB::Result::GitHub::Event;
# ABSTRACT:

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'github_event';

primary_column id        => {data_type => 'bigint', is_auto_increment => 1};
unique_column github_id  => {data_type => 'bigint', is_nullable => 0};
column github_user_id    => {data_type => 'bigint', is_nullable => 0};
column github_repo_id    => {data_type => 'bigint', is_nullable => 0};
column github_event_type => {data_type => 'text', is_nullable => 0};
column github_event_date => {data_type => 'timestamp with time zone', is_nullable => 0};

has_one 'repo', 'DDGC::DB::Result::GitHub::Repo', 'github_repo_id';
has_one 'user', 'DDGC::DB::Result::GitHub::User', 'github_user_id';

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
