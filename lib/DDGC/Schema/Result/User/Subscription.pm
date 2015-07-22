package DDGC::Schema::Result::User::Subscription;
# ABSTRACT: Activity feed subscription result class

use Moo;
extends 'DDGC::Schema::Result';
use DBIx::Class::Candy;

table 'user_subscription';

column id => {
    data_type => 'bigint',
    is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
    data_type   => 'bigint',
    is_nullable => 0,
};

column category => {
    data_type => 'text',
    is_nullable => 0,
};

column action => {
    data_type => 'text',
    is_nullable => 1,
};

column meta1 => {
    data_type => 'text',
    is_nullable => 1,
};

column meta2 => {
    data_type => 'text',
    is_nullable => 1,
};

column meta3 => {
    data_type => 'text',
    is_nullable => 1,
};

belongs_to 'user', 'DDGC::Schema::Result::User', 'users_id';

1;

