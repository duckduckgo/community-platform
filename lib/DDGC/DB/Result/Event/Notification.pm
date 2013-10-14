package DDGC::DB::Result::Event::Notification;
# ABSTRACT: Notification of a specific user for a specific event

use Moose;
use MooseX::NonMoose;
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

column event_notification_group_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column user_notification_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'event', 'DDGC::DB::Result::Event', 'event_id';
belongs_to 'event_notification_group', 'DDGC::DB::Result::Event::Notification::Group', 'event_notification_group_id';
belongs_to 'user_notification', 'DDGC::DB::Result::User::Notification', 'user_notification_id';

__PACKAGE__->indices(
	cycle_cycle_idx => 'cycle',
);

###############################

no Moose;
__PACKAGE__->meta->make_immutable;
