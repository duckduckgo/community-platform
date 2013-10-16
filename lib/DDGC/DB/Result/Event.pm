package DDGC::DB::Result::Event;
# ABSTRACT: Result class of an event

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

column users_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column action => {
	data_type => 'text',
	is_nullable => 0,
};

__PACKAGE__->add_context_relations;

# replaced by ::Result::Event::Relate
column related => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

# replaced by ::Result::Event::Relate
# pure visual used data, cache storage here
column language_ids => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

column notified => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

column updated => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
	set_on_update => 1,
};

# node id
column nid => {
	data_type => 'int',
	is_nullable => 0,
};

# process id on node
column pid => {
	data_type => 'int',
	is_nullable => 0,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', { join_type => 'left' };

has_many 'event_notifications', 'DDGC::DB::Result::Event::Notification', 'event_id';
has_many 'event_relates', 'DDGC::DB::Result::Event::Relate', 'event_id';

__PACKAGE__->indices(
	event_context_idx => 'context',
	event_context_id_idx => 'context_id',
	event_created_idx => 'created',
	event_pid_idx => 'pid',
);

before insert => sub {
	my ( $self ) = @_;
	$self->nid($self->ddgc->config->nid);
	$self->pid($self->ddgc->config->pid);
};

no Moose;
__PACKAGE__->meta->make_immutable;
