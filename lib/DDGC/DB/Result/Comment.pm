package DDGC::DB::Result::Comment;

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'comment';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column context => {
	data_type => 'text',
	is_nullable => 0,
};

column context_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column content => {
	data_type => 'text',
	is_nullable => 0,
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

column parent_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', { join_type => 'left' };
belongs_to 'parent', 'DDGC::DB::Result::Comment', 'parent_id', { join_type => 'left' };
has_many 'children', 'DDGC::DB::Result::Comment', 'parent_id';

sub get_context_obj {
	my ( $self ) = @_;
	if ( $self->has_context_obj ) {
		return $self->result_source->schema->resultset($1)->find($self->context_id);
	}
	return;
}

after insert => sub {
	my ( $self ) = @_;
	$self->add_event('insert');
};

after update => sub {
	my ( $self ) = @_;
	$self->add_event('update');
};

sub has_context_obj {
	my ( $self ) = @_;
	return $self->context =~ m/^DDGC::DB::Result::(.*)$/ ? 1 : 0;
}

sub event_related {
	my ( $self ) = @_;
	my @related;
	if ( $self->parent_id ) {
		push @related, [(ref $self), $self->parent_id];
	}
	if ( $self->has_context_obj ) {
		push @related, [$self->context, $self->context_id];
		push @related, [$self->get_context_obj->event_related] if $self->get_context_obj->can('event_related');
	}
	return @related;
}

###############################

no Moose;
__PACKAGE__->meta->make_immutable;
