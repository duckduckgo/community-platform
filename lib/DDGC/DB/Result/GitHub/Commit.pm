package DDGC::DB::Result::GitHub::Commit;
# ABSTRACT:

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'github_commit';

primary_column id               => {data_type => 'bigint', is_auto_increment => 1};
column github_repo_id           => {data_type => 'bigint', is_nullable => 0};
column github_user_id_author    => {data_type => 'bigint', is_nullable => 1};
column github_user_id_committer => {data_type => 'bigint', is_nullable => 1};
column sha                      => {data_type => 'text',   is_nullable => 0};
column message                  => {data_type => 'text',   is_nullable => 1};
column author_date              => {data_type => 'timestamp without time zone', is_nullable => 0};
column author_email             => {data_type => 'text',   is_nullable => 0};
column author_name              => {data_type => 'text',   is_nullable => 0};
column committer_date           => {data_type => 'timestamp without time zone', is_nullable => 0};
column committer_email          => {data_type => 'text',   is_nullable => 0};
column committer_name           => {data_type => 'text',   is_nullable => 0};
column created                  => {data_type => 'timestamp with time zone', set_on_create  => 1};
column updated                  => {data_type => 'timestamp with time zone', set_on_create  => 1};
column gh_data                  => {
    data_type          => 'text',
    is_nullable        => 0,
    serializer_class   => 'JSON',
    serializer_options => { convert_blessed => 1, utf8 => 1, pretty => 1 },
};

unique_constraint [qw( sha github_repo_id )];

belongs_to github_repo => 'DDGC::DB::Result::GitHub::Repo',
    { 'foreign.id' => 'self.github_repo_id' },
    { on_delete => 'cascade' };

belongs_to github_user_author => 'DDGC::DB::Result::GitHub::User',
    { 'foreign.id' => 'self.github_user_id_author' },
    { on_delete => 'cascade', join_type => 'left' };

belongs_to github_user_committer => 'DDGC::DB::Result::GitHub::User',
    { 'foreign.id' => 'self.github_user_id_committer' },
    { on_delete => 'cascade', join_type => 'left' };

no Moose;
__PACKAGE__->meta->make_immutable;
