package DDGC::DB::Result::Systemtask;
# ABSTRACT:

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'systemtask';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

unique_column key => {
	data_type => 'text',
	is_nullable => 0,
};

column server => {
	data_type => 'text',
	is_nullable => 0,
};

column pid => {
	data_type => 'int',
	is_nullable => 0,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
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

# node id
column nid => {
	data_type => 'int',
	is_nullable => 1,
};

# process id on node
column pid => {
	data_type => 'int',
	is_nullable => 1,
};

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
