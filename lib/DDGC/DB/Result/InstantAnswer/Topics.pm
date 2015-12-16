package DDGC::DB::Result::InstantAnswer::Topics;
# ABSTRACT: Instant Answer topics

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'instant_answer_topics';

column instant_answer_id => {
        data_type => 'text',
};

column topics_id => {
        data_type => 'bigint',
};

primary_key (qw/instant_answer_id topics_id/);

after insert => sub { $_[0]->schema->resultset('InstantAnswer::LastUpdated')->touch; };
after update => sub { $_[0]->schema->resultset('InstantAnswer::LastUpdated')->touch; };
after delete => sub { $_[0]->schema->resultset('InstantAnswer::LastUpdated')->touch; };

belongs_to 'instant_answer', 'DDGC::DB::Result::InstantAnswer', 'instant_answer_id', {on_delete => 'cascade'};
belongs_to 'topic', 'DDGC::DB::Result::Topic', 'topics_id', {on_delete => 'cascade'};

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
