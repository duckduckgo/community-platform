package DDGC::DB::Result::CycleTime;
# ABSTRACT: Track last time envoy ran for a given cycle

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'cycle_time';

column cycle_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column last_run => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
	set_on_update => 1,
};

primary_key (qw/ cycle_id /);

no Moose;
__PACKAGE__->meta->make_immutable;

