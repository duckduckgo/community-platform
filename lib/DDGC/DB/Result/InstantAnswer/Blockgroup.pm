package DDGC::DB::Result::InstantAnswer::Blockgroup;
# ABSTRACT:  Instant Answer Blockgroup

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'instant_answer_blockgroup';

column id => {
	data_type => 'serial',
	is_nullable => 0,
};

column blockgroup => {
	data_type => 'varchar',
	size => 20,
	is_nullable => 0
};

primary_key (id);

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
