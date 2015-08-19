package DDGC::DB::Result::InstantAnswer::Users;
# ABSTRACT: Users with write access to IA pages

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'instant_answer_users';

column instant_answer_id => {
	data_type => 'text',
};

column users_id => {
	data_type => 'bigint',
};

primary_key (qw/instant_answer_id users_id/);

belongs_to 'instant_answer', 'DDGC::DB::Result::InstantAnswer', 'instant_answer_id', {on_delete => 'cascade'};
belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';


no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );

