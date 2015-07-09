package DDGC::DB::Result::GitHub::Fork;
# ABSTRACT:

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'github_fork';

primary_column id          => {data_type => 'bigint', is_auto_increment => 1};
unique_column  github_id   => {data_type => 'bigint', is_nullable => 0};
column github_repo_id      => {data_type => 'bigint', is_nullable => 0};
column github_user_id      => {data_type => 'bigint', is_nullable => 0};
column full_name           => {data_type => 'text',   is_nullable => 0};
column pushed_at           => {data_type => 'timestamp with time zone', is_nullable => 0};
column created_at          => {data_type => 'timestamp with time zone', is_nullable => 0};
column updated_at          => {data_type => 'timestamp with time zone', is_nullable => 0};
column gh_data             => {
    data_type          => 'text',
    is_nullable        => 0,
    serializer_class   => 'JSON',
    serializer_options => { convert_blessed => 1, pretty => 1 },
};

belongs_to github_repo => 'DDGC::DB::Result::GitHub::Repo',
    { 'foreign.id' => 'self.github_repo_id' },
    { on_delete => 'cascade' };

belongs_to github_user => 'DDGC::DB::Result::GitHub::User',
    { 'foreign.id' => 'self.github_user_id' },
    { on_delete => 'cascade' };

sub owner_name { my @p = split('/',$_[0]->full_name); return $p[0]; }
sub repo_name  { my @p = split('/',$_[0]->full_name); return $p[1]; }

no Moose;
__PACKAGE__->meta->make_immutable;
