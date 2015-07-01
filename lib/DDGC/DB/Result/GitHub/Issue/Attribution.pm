package DDGC::DB::Result::GitHub::Issue::Attribution;
# ABSTRACT:

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'github_issue_attribution';

primary_column id        => {data_type => 'bigint', is_auto_increment => 1};
unique_column github_id  => {data_type => 'bigint', is_nullable       => 0};
column users_id          => {data_type => 'bigint', is_nullable       => 0};
column reason            => {data_type => 'text',   is_nullable       => 0};
column approved_by_admin => {data_type => 'int',    is_nullable       => 0, default_value => 0};
column github_issue_id   => {data_type => 'bigint', is_nullable       => 0};
column created           => {data_type => 'timestamp with time zone', set_on_create => 1};

belongs_to user => 'DDGC::DB::Result::User',
    { 'foreign.id' => 'self.users_id' },
    { on_delete => 'no action' };

belongs_to github_issue => 'DDGC::DB::Result::GitHub::Issue',
    { 'foreign.id' => 'self.github_issue_id' },
    { on_delete => 'cascade' };

no Moose;
__PACKAGE__->meta->make_immutable;
