package DDGC::DB::Result::ActivityFeed;
# ABSTRACT: Activity feed reault class

use Moo;
extends 'DBIx::Class::Core';
use DBIx::Class::Candy;

table 'activity_feed';

# See DDGC::Schema::Result::ActivityFeed for docs

column id => {
    data_type => 'bigint',
    is_auto_increment => 1,
};
primary_key 'id';

column created => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
};

column category => {
    data_type => 'text',
    is_nullable => 0,
};

column action => {
    data_type => 'text',
    is_nullable => 0,
    default_value => 'created',
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

column for_role => {
    data_type => 'int',
    is_nullable => 1,
};

1;
