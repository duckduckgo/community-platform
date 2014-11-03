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
	is_nullable => 1,
};

# eg DDG::Goodie::Calculator
column perl_module => {
	data_type => 'text',
	is_nullable => 1,
};

# idea, planning, alpha, beta, qa, ready, live, disabled
column dev_milestone => {
	data_type => 'text',
	is_nullable => 1,
};

# JSON associative array of dates when milestones reached { idea: "date", planning: "date" , .. }
column milestone_dates => {
	data_type => 'text',
	is_nullable => 1,
};

# freeform one-liner describing the current status
column status => {
	data_type => 'text',
	is_nullable => 1,
};

# aka 'type': goodie, spice, fathead, longtail, some future repos
column repo => {
	data_type => 'text',
	is_nullable => 1,
};

# aka team
column topic=> {
	data_type => 'text',
	is_nullable => 1,
};

# json array of all relevant files (.pm, .t, js, handlebars, etc)
column code => {
	data_type => 'text',
	is_nullable => 1,
};

# external api name
column src_name => {
	data_type => 'text',
	is_nullable => 1,
};

# top-level url of the source website
column src_url => {
	data_type => 'text',
	is_nullable => 1,
};

# documentation url
column src_api_documentation => {
	data_type => 'text',
	is_nullable => 1,
};

# favicon url, if necessary. can usually be inferred from the domain
column icon_url => {
	data_type => 'text',
	is_nullable => 1,
};

# screenshot url
column screenshot => {
	data_type => 'text',
	is_nullable => 1,
};

# eg 'info', broad brush for v1.
column template_group => {
	data_type => 'text',
	is_nullable => 1,
};

# json list of named custom templates
column custom_templates => {
	data_type => 'text',
	is_nullable => 1,
};

# primary example query
column example_query => {
	data_type => 'text',
	is_nullable => 1,
};

# json, aka secondary queries
column other_queries => {
	data_type => 'text',
	is_nullable => 1,
};

# signal_from
column signal_from => {
	data_type => 'text',
	is_nullable => 1,
};

# tab
column tab => {
	data_type => 'text',
	is_nullable => 1,
};

# attribution
column attribution_orig => {
	data_type => 'text',
	is_nullable => 1,
};

# template
column template => {
	data_type => 'text',
	is_nullable => 1,
};

# attribution
column attribution => {
	data_type => 'text',
	is_nullable => 1,
};

# screenshots
column screenshots => {
	data_type => 'text',
	is_nullable => 1,
};

# unsafe
column unsafe => {
	data_type => 'integer',
	is_nullable => 1,
};

# for staging updates to metadata
column updates => {
    data_type => 'text',
    is_nullable => 1,
    serializer_class => 'JSON'
};

has_many 'issues', 'DDGC::DB::Result::InstantAnswer::Issues', 'instant_answer_id';
has_many 'blocks', 'DDGC::DB::Result::InstantAnswer::Blocks', 'instant_answer_id';

has_many 'instant_answer_users', 'DDGC::DB::Result::InstantAnswer::Users', 'instant_answer_id';
many_to_many 'users', 'instant_answer_users', 'user';

no Moose;
__PACKAGE__->meta->make_immutable;

