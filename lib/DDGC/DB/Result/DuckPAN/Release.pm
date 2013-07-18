package DDGC::DB::Result::DuckPAN::Release;
# ABSTRACT: Releases made on DuckPAN

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'duckpan_release';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column name => {
	data_type => 'text',
	is_nullable => 0,
};

column version => {
	data_type => 'text',
	is_nullable => 0,
};

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column filename => {
	data_type => 'text',
	is_nullable => 0,
	default_value => 1,
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

unique_constraint [qw/ name version /];

no Moose;
__PACKAGE__->meta->make_immutable;
