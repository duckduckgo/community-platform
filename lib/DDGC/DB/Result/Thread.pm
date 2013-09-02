package DDGC::DB::Result::Thread;
# ABSTRACT: Dukgo.com Forum thread

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'thread';

sub u { [ 'Forum', 'thread', $_[0]->id, $_[0]->key ] }
sub u_edit { [ 'Forum::My', 'edit', $_[0]->id ] }
sub u_delete { [ 'Forum::My', 'delete', $_[0]->id ] }

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

# cotent source comment
column comment_id => {
	data_type => 'bigint',
	is_nullable => 1,
};
sub content { $_[0]->comment->content }
sub html { $_[0]->comment->html }

column key => {
	data_type => 'text',
	is_nullable => 0,
	indexed => 1,
};

column title => {
	data_type => 'text',
	is_nullable => 0,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

column sticky => {
	data_type => 'int',
	default_value => 0,
};

column readonly => {
	data_type => 'int',
	default_value => 0,
};

column done => {
	data_type => 'int',
	default_value => 0,
};

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

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'comment', 'DDGC::DB::Result::Comment', 'comment_id', { 
	on_delete => 'no action',
	join_type => 'left'
};

before insert => sub {
	my ( $self ) = @_;
	unless ($self->key) {
		$self->key($self->get_url);
	}
};

after insert => sub {
	my ( $self ) = @_;
	$self->add_event('insert');
};

after update => sub {
	my ( $self ) = @_;
	$self->add_event('update');
};

sub comments {
	my ( $self ) = @_;
	return $self->schema->resultset('Comment')->search_rs({
		'me.context' => $self->i_context,
		'me.context_id' => $self->i_context_id,
		'me.parent_id' => $self->comment_id,
	});
}

sub get_url {
	my $self = shift;
	my $key = substr(lc($self->title),0,50);
	$key =~ s/[^a-z0-9]+/-/g;
	$key =~ s/-+/-/g;
	$key =~ s/-$//;
	$key =~ s/^-//;
	return $key;
}

no Moose;
__PACKAGE__->meta->make_immutable;
