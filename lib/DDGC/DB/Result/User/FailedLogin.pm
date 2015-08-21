package DDGC::DB::Result::User::FailedLogin;
# ABSTRACT: Result class for tracking login failures

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'user_failedlogin';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column timestamp => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
