package DDGC::DB::Result::InstantAnswer;
# ABSTRACT: DuckDuckHack Instant Answer Page

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'instant_answer';

sub u { [ 'InstantAnswer', 'view', $_[0]->id ] }

column id => {
	data_type => 'text',
};
primary_key 'id';

# userland name
column name => {
	data_type => 'text',
};

# userland description of what the IA does
column description => {
	data_type => 'text',
};

# eg DDG::Goodie::Calculator
column perl_module => {
	data_type => 'text',
};

# idea, planning, alpha, beta, qa, ready, live, disabled
column dev_milestone => {
	data_type => 'text',
};

# JSON associative array of dates when milestones reached { idea: "date", planning: "date" , .. }
column milestone_dates => {
	data_type => 'text',
};

# freeform one-liner describing the current status
column status => {
	data_type => 'text',
};

# aka 'type': goodie, spice, fathead, longtail, some future repos
column repo => {
	data_type => 'text',
};

# aka team
column topic=> {
	data_type => 'text',
};

# json array of all relevant files (.pm, .t, js, handlebars, etc)
column code => {
	data_type => 'text',
};

# external api name
column source_name => {
	data_type => 'text',
};

# top-level url of the source website
column source_url => {
	data_type => 'text',
};

# documentation url
column source_api_documentation => {
	data_type => 'text',
};

# favicon url, if necessary. can usually be inferred from the domain
column icon_url => {
	data_type => 'text',
};

# screenshot url
column screenshot => {
	data_type => 'text',
};

# eg 'info', broad brush for v1.
column template_group => {
	data_type => 'text',
};

# json list of named custom templates
column custom_templates => {
	data_type => 'text',
};

# primary example query
column example_query => {
	data_type => 'text',
};

# json, aka secondary queries
column other_queries => {
	data_type => 'text',
};

has_many 'issues', 'DDGC::DB::Result::InstantAnswer::Issues', 'instant_answer_id';
has_many 'blocks', 'DDGC::DB::Result::InstantAnswer::Blocks', 'instant_answer_id';

no Moose;
__PACKAGE__->meta->make_immutable;

