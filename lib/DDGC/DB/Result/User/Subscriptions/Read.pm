package DDGC::DB::Result::User::Subscriptions::Read;
# ABSTRACT: DDGC::Subscriptions read by / emailed to a user.

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'user_subscriptions_read';

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column category_id => {
	data_type => 'text',
	is_nullable => 0,
};

primary_key (qw/ category_id users_id /);

column read => {
	data_type => 'timestamp with time zone',
};

column emailed => {
	data_type => 'timestamp with time zone',
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';

no Moose;
__PACKAGE__->meta->make_immutable;
