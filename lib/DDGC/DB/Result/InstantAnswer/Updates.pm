package DDGC::DB::Result::InstantAnswer::Updates;
# ABSTRACT: DuckDuckHack Instant Answer Page

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'instant_answer_updates';

sub u { [ 'InstantAnswer', 'update', $_[0]->id, $_[0]->instant_answer_id ] }

# f_key to ia table
column instant_answer_id => {
    data_type => 'text'
};

column field => {
	data_type => 'text',
};

column value => {
	data_type => 'text',
};

column timestamp => {
    data_type => 'text'
};

belongs_to 'instant_answer', 'DDGC::DB::Result::InstantAnswer', 'instant_answer_id', {on_delete => 'cascade'};

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );

