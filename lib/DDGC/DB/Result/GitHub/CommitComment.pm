package DDGC::DB::Result::CommitComment;

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'github_commit_comment';

primary_column commit_id => { data_type => 'bigint', is_nullable => 0 };
column github_repo_id    => { data_type => 'bigint', is_nullable => 0 };
column github_user_id    => { data_type => 'bigint', is_nullable => 0 };
column position          => { data_type => 'bigint', is_nullable => 0 };
column line              => { data_type => 'bigint', is_nullable => 0 };
primary_column number    => { data_type => 'bigint', is_nullable => 0 };
column body              => { data_type => 'text', is_nullable => 0 };
column created_at        => { data_type => 'timestamp', is_nullable => 0 };
column gh_data           => { data_type => 'text', is_nullable => 0 };

unique_constraint [qw( commit_id number)];

belongs_to 'repo', 'DDGC::DB::Result::Github::Repo', 'github_repo_id';
belongs_to 'user', 'DDGC::DB::Result::Github::User', 'contributor_id';

no Moose;
__PACKAGE__->meta->make_immutable( inline_contrustor => 0 );
