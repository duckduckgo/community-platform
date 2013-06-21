package DDGC::DB::Result::Event::Notification;

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'event_notification';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column event_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column cycle => {
	data_type => 'int',
	is_nullable => 0,
};

column cycle_time => {
	data_type => 'timestamp with time zone',
	is_nullable => 1,
};

column done => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
};

column sent => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'event', 'DDGC::DB::Result::Event', 'event_id';

###############################

no Moose;
__PACKAGE__->meta->make_immutable;
