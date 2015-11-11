package DDGC::DB::Result::InstantAnswer::Traffic;
# ABSTRACT: Users with write access to IA pages

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'instant_answer_traffic';

column date => {
	data_type => 'date',
};

column answer_id => {
	data_type => 'text',
};

column pixel_type => {
    data_type => 'text',
};

column count => {
    data_type => 'bigint',
};

column id => {
	data_type => 'serial',
    is_auto_increment => 1,
    is_nullable => 0,
};

primary_key ('id');

#belongs_to 'instant_answer', 'DDGC::DB::Result::InstantAnswer', 'answer_id', {on_delete => 'cascade'};

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );

