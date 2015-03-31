package DDGC::DB::Result::InstantAnswer;
# ABSTRACT: DuckDuckHack Instant Answer Page

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;
use JSON;

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

# JSON string cointaining parameters such as
# fallback_timeout, for IAs with slow upstream providers
column answerbar => {
    data_type => 'text',
    is_nullable => 1,
    is_json => 1,
};

# eg DDG::Goodie::Calculator
column perl_module => {
	data_type => 'text',
	is_nullable => 1,
};

# JSON array of dependencies
column perl_dependencies => {
    data_type => 'text',
    is_nullable => 1,
    is_json => 1,
};

# idea, planning, alpha, beta, qa, ready, live, disabled
column dev_milestone => {
	data_type => 'text',
	is_nullable => 1,
};

# is the IA live or not live?
column is_live => {
    data_type => 'integer',
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
    is_json => 1,
    serializer_class => 'JSON'
};

# json array of all relevant files (.pm, .t, js, handlebars, etc)
column code => {
	data_type => 'text',
	is_nullable => 1,
    is_json => 1,
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

# api status page
column api_status_page => {
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

# JSON array of mockups urls
column mockups => {
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

# JSON array of triggers
column triggers => {
    data_type => 'text',
    is_nullable => 1,
    is_json => 1,
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
    is_json => 1,
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
    is_json => 1,
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
    is_json => 1,
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

# IA type
column type => {
    data_type => 'text',
    is_nullable => 1,
};

# IA producer (must be an admin)
column producer => {
    data_type => 'text',
    is_nullable => 1,
};

# IA designer (must be an admin)
column designer => {
    data_type => 'text',
    is_nullable => 1,
};

# IA developer
column developer => {
    data_type => 'text',
    is_nullable => 1,
    is_json => 1,
};

# code review (can be completed, aka '1', or not completed, aka '0')
column code_review => {
    data_type => 'integer',
    is_nullalbe => 1,
};

# design review (can be completed, aka '1', or not completed, aka '0')
column design_review => {
    data_type => 'integer',
    is_nullalbe => 1,
};

# name of the test machine on which the IA is on when in QA
column test_machine => {
    data_type => 'text',
    is_nullable => 1,
};

# test results on IE 8
column browsers_ie => {
    data_type => 'integer',
    is_nullable => 1,
};

# test results on Google Chrome
column browsers_chrome => {
    data_type => 'integer',
    is_nullable => 1,
};

# test results on Firefox
column browsers_firefox => {
    data_type => 'integer',
    is_nullable => 1,
};

# test results on Safari
column browsers_safari => {
    data_type => 'integer',
    is_nullable => 1,
};

# test results on Opera
column browsers_opera => {
    data_type => 'integer',
    is_nullable => 1,
};

# test results on Android
column mobile_android => {
    data_type => 'integer',
    is_nullable => 1,
};

# test results on iOS
column mobile_ios => {
    data_type => 'integer',
    is_nullable => 1,
};

# test results for relevancy
column tested_relevancy => {
    data_type => 'integer',
    is_nullable => 1,
};

# test results on staging machine
column tested_staging => {
    data_type => 'integer',
    is_nullable => 1,
};

column src_options => {
    data_type => 'text',
    is_nullable => 1,
    is_json => 1,
};

column src_id => {
    data_type => 'integer',
    is_nullable => 1,
};

column src_domain => {
    data_type => 'text',
    is_nullable => 1,
};

has_many 'issues', 'DDGC::DB::Result::InstantAnswer::Issues', 'instant_answer_id';
has_many 'blocks', 'DDGC::DB::Result::InstantAnswer::Blocks', 'instant_answer_id';
has_many 'updates', 'DDGC::DB::Result::InstantAnswer::Updates', 'instant_answer_id';

has_many 'instant_answer_users', 'DDGC::DB::Result::InstantAnswer::Users', 'instant_answer_id';
many_to_many 'users', 'instant_answer_users', 'user';

has_many 'instant_answer_topics', 'DDGC::DB::Result::InstantAnswer::Topics', 'instant_answer_id';
many_to_many 'topics', 'instant_answer_topics', 'topic';

sub TO_JSON {
    my $ia = shift;
    my %data = $ia->get_columns;
    while( my($field,$value) = each %data ){
        my $column_data = $ia->column_info($field);
        next unless defined $data{$field} && $column_data->{is_json};

        warn $data{$field};
        if($field eq "topic"){
            $data{$field} =~ s/{/{"topics":[/;
            $data{$field} =~ s/}/]}/;
            warn $data{$field};
        }
        $data{$field} = from_json($data{$field})
    }

    return \%data;
}

no Moose;
__PACKAGE__->meta->make_immutable;

