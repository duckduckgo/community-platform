package DDGC::DB::Result::User::Notification;
# ABSTRACT: User notification setting result class

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'user_notification';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column user_notification_group_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column context_id => {
  data_type => 'bigint',
  is_nullable => 1,
};

# 1 = Instant (Not yet implemented)
# 2 = Hourly
# 3 = Daily
# 4 = Weekly

column cycle => {
	data_type => 'int',
	is_nullable => 0,
};

column xmpp => {
	data_type => 'int',
	default_value => 0,
};

# not yet supported
column cycle_time => {
	data_type => 'timestamp with time zone',
	is_nullable => 1,
};

# not yet supported
column last_check => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', {
	on_delete => 'cascade',	
};
belongs_to 'user_notification_group', 'DDGC::DB::Result::User::Notification::Group', 'user_notification_group_id', {
	on_delete => 'cascade',	
};
has_many 'event_notifications', 'DDGC::DB::Result::Event::Notification', 'user_notification_id', {
	cascade_delete => 1,
};

unique_constraint [qw/ user_notification_group_id context_id users_id /];

__PACKAGE__->indices(
	user_notification_cycle_idx => 'cycle',
	user_notification_context_id_idx => 'context_id',
);

###############################

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
