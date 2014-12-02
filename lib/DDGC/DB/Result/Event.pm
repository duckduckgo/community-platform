package DDGC::DB::Result::Event;
# ABSTRACT: Result class for events which match a subscription

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;

use namespace::autoclean;

table 'event';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

# Contributing user, generated the event
column users_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

# Subscription configuration entry
column subscription_id => {
	data_type => 'text',
	is_nullable => 0,
};

# ResultSet name
column object => {
	data_type => 'text',
	is_nullable => 0,
};

# Result id(s)
column object_ids => {
	data_type => 'bigint[]',
	is_nullable => 0,
};

# Context sensitive target or group object id.
# Examples:
#   - User who is subject of an @mention
#   - Language of contributed translations
column target_object_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

sub event_objects {
	my ( $self ) = @_;
	$self->ddgc->rs( $self->object )->search_rs({
		id => { -in => $self->object_ids }
	});
}

no Moose;
__PACKAGE__->meta->make_immutable;
