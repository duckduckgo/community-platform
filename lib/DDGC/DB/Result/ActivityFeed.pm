package DDGC::DB::Result::ActivityFeed;
# ABSTRACT: Activity feed reault class

use Moo;
extends 'DBIx::Class::Core';
use DBIx::Class::Candy;

table 'activity_feed';

column id => {
    data_type => 'bigint',
    is_auto_increment => 1,
};
primary_key 'id';

column created => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
};

column type => {
    data_type => 'text',
    is_nullable => 0,
};

column description => {
    data_type => 'text',
    is_nullable => 0,
};

column format => {
    data_type => 'text',
    default_value => 'markdown',
};

column for_user => {
    data_type => 'bigint',
    is_nullable => 1,
};

1;
