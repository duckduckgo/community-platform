package DDGC::DB::Result::GitHub::UserLink;
# ABSTRACT:

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'github_user_link';

primary_column users_id       => {data_type => 'bigint', is_nullable => 0};
column data                   => {data_type => 'text',   is_nullable => 0, serializer_class => 'JSON'};

1;
