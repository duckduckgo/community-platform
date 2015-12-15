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
sub uri {
    my ( $self, $params ) = @_;
    $self->ddgc->uri_for(
        sprintf( '/ia/view/%s', $self->meta_id ),
        $params
    );
}

column id => {
	data_type => 'text',
};
primary_key 'id';

# editable ID
column meta_id => {
    data_type => 'text',
    for_endpt => 1,
    pipeline => 1,
    show_as => 'id',
};

# userland name
column name => {
	data_type => 'text',
    for_endpt => 1,
    pipeline => 1
};

# userland description of what the IA does
column description => {
	data_type => 'text',
	is_nullable => 1,
    for_endpt => 1,
    pipeline => 1
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
    for_endpt => 1,
    pipeline => 1
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
    pipeline => 1,
    for_endpt => 1,
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
    for_endpt => 1
};

# aka 'type': goodie, spice, fathead, longtail, some future repos
column repo => {
	data_type => 'text',
	is_nullable => 1,
    for_endpt => 1,
    pipeline => 1
};

# aka team
column topic=> {
	data_type => 'text',
	is_nullable => 1,
    for_endpt => 1,
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
    for_endpt => 1
};

# top-level url of the source website
column src_url => {
	data_type => 'text',
	is_nullable => 1,
        for_endpt => 1
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
    is_json => 1
};

# primary example query
column example_query => {
	data_type => 'text',
	is_nullable => 1,
    for_endpt => 1,
    pipeline => 1
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
    for_endpt => 1
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
    for_endpt => 1
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

# IA type
column type => {
    data_type => 'text',
    is_nullable => 1,
};

# IA producer (must be an admin)
column producer => {
    data_type => 'text',
    is_nullable => 1,
    pipeline => 1,
    for_endpt => 1
};

# IA designer (must be an admin)
column designer => {
    data_type => 'text',
    is_nullable => 1,
    pipeline => 1,
    for_endpt => 1
};

# IA developer
column developer => {
    data_type => 'text',
    is_nullable => 1,
    pipeline => 1,
    is_json => 1,
    for_endpt => 1
};

# code review (can be completed, aka '1', or not completed, aka '0')
column code_review => {
    data_type => 'integer',
    is_nullable => 1,
};

# design review (can be completed, aka '1', or not completed, aka '0')
column design_review => {
    data_type => 'integer',
    is_nullable => 1,
};

# name of the test machine on which the IA is on when in QA
column test_machine => {
    data_type => 'text',
    is_nullable => 1,
    pipeline => 1
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
    for_endpt => 1
};

column is_stackexchange => {
    data_type => 'integer',
    is_nullable => 1,
    for_endpt => 1
};

column src_domain => {
    data_type => 'text',
    is_nullable => 1,
    for_endpt => 1
};

column dev_date => {
    data_type => 'date',
    is_nullable => 1,
    for_endpt => 1
};

column live_date => {
    data_type => 'date',
    is_nullable => 1,
    for_endpt => 1,
    pipeline => 1
};

column created_date => {
    data_type => 'date',
    is_nullable => 1,
    for_endpt => 1,
    pipeline => 1
};

column forum_link => {
    data_type => 'text',
    is_nullable => 1
};

column last_commit => {
    data_type => 'text',
    is_nullable => 1,
    is_json => 1,
    pipeline => 1
};

column last_comment => {
    data_type => 'text',
    is_nullable => 1,
    is_json => 1,
    pipeline => 1
};

column last_update => {
    data_type => 'text',
    is_nullable => 1,
    pipeline => 1
};

column all_comments => {
    data_type => 'text',
    is_nullable => 1,
    is_json => 1,
    pipeline => 1
};

column at_mentions => {
    data_type => 'text',
    is_nullable => 1,
    is_json => 1,
    pipeline => 1
};

column updated => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
    set_on_update => 1,
};

	
# Latest release in which an IA was updated
column release_version => {
    data_type => 'numeric',
    is_nullable => 1,
};

# Is it live or not?
column deployment_state => {
    data_type => 'varchar',
    size => 15,
    is_nullable => 1,
};

column blockgroup => {
	data_type => 'varchar',
	size => 20,
	is_nullable => 1,
	for_endpt => 1
};

has_many 'issues', 'DDGC::DB::Result::InstantAnswer::Issues', 'instant_answer_id';
has_many 'updates', 'DDGC::DB::Result::InstantAnswer::Updates', 'instant_answer_id';
has_many 'ideas', 'DDGC::DB::Result::Idea', 'instant_answer_id';

has_many 'instant_answer_users', 'DDGC::DB::Result::InstantAnswer::Users', 'instant_answer_id';
many_to_many 'users', 'instant_answer_users', 'user';

has_many 'instant_answer_topics', 'DDGC::DB::Result::InstantAnswer::Topics', 'instant_answer_id';
many_to_many 'topics', 'instant_answer_topics', 'topic';

has_many 'release_versions', 'DDGC::DB::Result::ReleaseVersion', 'instant_answer_id';

has_one 'blockgroup', 'DDGC::DB::Result::InstantAnswer::Blockgroup', 'blockgroup';

after insert => sub {
    my ( $self ) = @_;
    my $schema = $self->result_source->schema;
    $schema->resultset('ActivityFeed')->created_ia( {
        meta1        => $self->id,
        meta2        => join('', map { sprintf ':%s:', $_ }
            $self->topics->columns([qw/ name /])->all),
        description  => sprintf('Instant Answer Page [%s](%s) created!',
            $self->name, $self->uri( { activity_feed => 1 } ) ),
    } );

    $schema->resultset('InstantAnswer::LastUpdated')->touch;
};

after update => sub { $_[0]->schema->resultset('InstantAnswer::LastUpdated')->touch; };

sub create_update_activity {
    my ( $self, $meta3, $description ) = @_;
    $self->result_source->schema->resultset('ActivityFeed')->updated_ia( {
        meta1        => $self->id,
        meta2        => $self->topics->join_for_activity_meta( 'name' ),
        meta3        => $meta3,
        description  => $description,
    } );
}

sub _generate_updates {
    my ( $self, $update ) = @_;

    while ( my ($column, $value) = each $update ) {

        if ( $column eq 'dev_milestone' ) {
            $self->create_update_activity(
                $column,
                sprintf( 'Instant Answer [%s](%s) dev milestone changed to %s',
                    $self->name,
                    $self->uri( { from => 'notification' } ),
                    $value
                ),
            );
        }

    }
}

around update => sub {
    my ( $next, $self, @extra ) = @_;
    my $update = $extra[0];

    my $ret = $self->$next( @extra );
    return $ret if (!$ret);
    return $ret if $ENV{DDGC_IA_AUTOUPDATES};

    $self->_generate_updates( $update );

    return $ret;
};

# returns a hash ref of all IA data.  Same idea as hashRefInflator
# but this takes care of deserialization for you.
sub TO_JSON {
    my ($ia, $type) = @_;
    
    my %data = $ia->get_columns;
    my %result;
    my @topics = map { $_->name } $ia->topics;
    $result{topic} = \@topics;

    while( my($key,$value) = each %data ){
        my $column_data = $ia->column_info($key);

        next if $result{$key};

        if ($column_data->{show_as}) {
            $key = $column_data->{show_as};
        }

        next if ($type && !$column_data->{$type});

        $result{$key} = $value;
        
        next unless $data{$key} && $column_data->{is_json};
        $result{$key} = from_json($data{$key});
    }
    return \%result;
}

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );

