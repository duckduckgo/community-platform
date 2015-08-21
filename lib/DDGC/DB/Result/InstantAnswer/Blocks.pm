package DDGC::DB::Result::InstantAnswer::Blocks;
# ABSTRACT: DuckDuckHack Instant Answer Blocks

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'instant_answer_blocks';

sub u { [ 'InstantAnswer', 'block', $_[0]->id, $_[0]->blockgroup ] }

column instant_answer_id => {
	data_type => 'text',
};

column blockgroup => {
	data_type => 'text',
};

primary_key (qw/instant_answer_id blockgroup/);

belongs_to 'instant_answer', 'DDGC::DB::Result::InstantAnswer', 'instant_answer_id', {on_delete => 'cascade'};

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );

