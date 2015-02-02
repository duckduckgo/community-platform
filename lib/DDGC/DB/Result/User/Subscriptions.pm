package DDGC::DB::Result::User::Subscriptions;
# ABSTRACT: DDGC::Subscriptions a user has opted into.

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'user_subscriptions';

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column subscription_id => {
	data_type => 'text',
	is_nullable => 0,
};

# Subscriptions to specific object instances.
# e.g. Following a thread
column target_object_id => {
	data_type => 'bigint',
	is_nullable => 0,
	default_value => 0,
};

primary_key(qw/ users_id subscription_id target_object_id /);

column notification_cycle => {
	data_type => 'bigint',
	is_nullable => 0,
	default_value => 0,
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

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';

has_many 'events', 'DDGC::DB::Result::Event', sub {
	my ( $args ) = @_;
	return {
		-and => {
			"$args->{foreign_alias}.subscription_id" => { -ident => "$args->{self_alias}.subscription_id" },
			-or => [
				{ "$args->{self_alias}.target_object_id" => 0 },
				{ "$args->{self_alias}.target_object_id" => "$args->{foreign_alias}.object_id[1]" },
			],
		},
	}
};

no Moose;
__PACKAGE__->meta->make_immutable;
