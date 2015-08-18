package DDGC::Schema::Result::User::Role;

# ABSTRACT: A give user's roles, e.g. admin, translation manager

use Moo;
extends 'DBIx::Class::Core';
use DBIx::Class::Candy;

table 'user_role';

column users_id => {
    data_type   => 'bigint',
    is_nullable => 0,
};

column role => {
    data_type => 'int',
    is_nullable => 0,
};

primary_key (qw/ users_id role /);

belongs_to 'user', 'DDGC::Schema::Result::User', 'users_id';

1;
