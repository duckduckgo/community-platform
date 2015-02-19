package DDGC::DB::Result::InstantAnswer::Updates;
# ABSTRACT: DuckDuckHack Instant Answer Page

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'instant_answer_updates';

sub u { [ 'InstantAnswer', 'update', $_[0]->id, $_[0]->id ] }

column id => {
	data_type => 'text',
};

column field => {
	data_type => 'text',
	is_nullable => 1,
};

column body => {
	data_type => 'text',
	is_nullable => 1,
};

primary_key (qw/id/);

belongs_to 'instant_answer', 'DDGC::DB::Result::InstantAnswer', 'id', {on_delete => 'cascade'};

no Moose;
__PACKAGE__->meta->make_immutable;

