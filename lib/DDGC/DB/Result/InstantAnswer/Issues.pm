package DDGC::DB::Result::InstantAnswer::Issues;
# ABSTRACT: DuckDuckHack Instant Answer Page

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'instant_answer_issues';

sub u { [ 'InstantAnswer', 'issue', $_[0]->id, $_[0]->issue_id ] }

column instant_answer_id => {
	data_type => 'text',
};

column issue_id => {
	data_type => 'text',
};

column title => {
	data_type => 'text',
	is_nullable => 1,
};

column body => {
	data_type => 'text',
	is_nullable => 1,
};

column tags => {
	data_type => 'text',
	is_nullable => 1,
    serializer_class => 'JSON',
};

column repo => {
	data_type => 'text',
};

column is_pr => {
    data_type => 'text',
    is_nullable => 1,
};

column date => {
    data_type => 'text',
    is_nullable => 1,
};

column author => {
    data_type => 'text',
    is_nullable => 1,
};

column status => {
    data_type => 'text',
    is_nullable => 1,
};

primary_key (qw/issue_id repo/);

after insert => sub { $_[0]->schema->resultset('InstantAnswer::LastUpdated')->touch; };
after update => sub { $_[0]->schema->resultset('InstantAnswer::LastUpdated')->touch; };

belongs_to 'instant_answer', 'DDGC::DB::Result::InstantAnswer', 'instant_answer_id', {on_delete => 'cascade'};

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );

