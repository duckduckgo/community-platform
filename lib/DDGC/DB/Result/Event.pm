package DDGC::DB::Result::Event;

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'event';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column action => {
	data_type => 'text',
	is_nullable => 0,
};

###########
column context => {
	data_type => 'text',
	is_nullable => 0,
};
column context_id => {
	data_type => 'bigint',
	is_nullable => 0,
};
with 'DDGC::DB::Role::HasContext';
###########

column related => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

# pure visual used data, cache storage here
column language_ids => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

column notified => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

column updated => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
	set_on_update => 1,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', { join_type => 'left' };
has_many 'event_notifications', 'DDGC::DB::Result::Event::Notification', 'event_id';

no Moose;
__PACKAGE__->meta->make_immutable;
