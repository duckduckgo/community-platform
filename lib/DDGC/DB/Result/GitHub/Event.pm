package DDGC::DB::Result::GitHub::Event;
# ABSTRACT:

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'github_event';

primary_column id        => {data_type => 'bigint', is_auto_increment => 1};
column github_user_id    => {data_type => 'bigint', is_nullable => 0};
column github_repo_id    => {data_type => 'bigint', is_nullable => 0};
column github_event_type => {data_type => 'text', is_nullable => 0};
column created_at        => {data_type => 'timestamp with time zone', is_nullable => 0};

belongs_to github_repo => 'DDGC::DB::Result::GitHub::Repo',
    { 'foreign.id' => 'self.github_repo_id' },
    { on_delete    => 'cascade' };

belongs_to github_user => 'DDGC::DB::Result::GitHub::User',
    { 'foreign.id' => 'self.github_user_id' },
    { on_delete    => 'cascade' };

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
