package DDGC::DB::Result::Comment;
# ABSTRACT: Comment result class

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'comment';

sub u { 
	my ( $self ) = @_;
	if ( my $context_obj = $self->get_context_obj ) {
		if ($context_obj->can('u_comments')) {
			my $u = $context_obj->u_comments;
			return $u if $u;
		}
		if ($context_obj->can('u')) {
			my $u = $context_obj->u;
			return $u if $u;
		}
	}
	return;
}

sub u_comments { [ 'Forum', 'comment', $_[0]->id ] }

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

###########
column context => {
	data_type => 'text',
	is_nullable => 0,
  indexed => 1,
};
column context_id => {
	data_type => 'bigint',
	is_nullable => 0,
	indexed => 1,
};
with 'DDGC::DB::Role::HasContext';
###########

__PACKAGE__->add_context_relations;

column content => {
	data_type => 'text',
	is_nullable => 0,
};
sub html { $_[0]->ddgc->markup->html($_[0]->content) }

column deleted => {
	data_type => 'int',
	default_value => 0,
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
sub root_comment { $_[0]->parent_id ? 0 : 1 }

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'parent', 'DDGC::DB::Result::Comment', 'parent_id', { join_type => 'left' };
has_many 'children', 'DDGC::DB::Result::Comment', 'parent_id';

sub comments { shift->children_rs }

after insert => sub {
	my ( $self ) = @_;
	$self->add_event('insert');
};

after update => sub {
	my ( $self ) = @_;
	$self->add_event('update');
};

sub event_related {
	my ( $self ) = @_;
	my @related;
	if ( $self->parent_id ) {
		push @related, [(ref $self), $self->parent_id];
	}
	if ( $self->context_resultset ) {
		push @related, [$self->context, $self->context_id];
		push @related, [$self->get_context_obj->event_related] if $self->get_context_obj->can('event_related');
	}
	return @related;
}

###############################

no Moose;
__PACKAGE__->meta->make_immutable;

1;
