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

column forum => {
  data_type => 'int',
  is_nullable => 0,
  default_value => 1,
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

__PACKAGE__->add_antispam_functionality;

column old_url => {
	data_type => 'text',
	is_nullable => 1,
};

has_many 'screenshot_threads', 'DDGC::DB::Result::Screenshot::Thread', 'thread_id';

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'comment', 'DDGC::DB::Result::Comment', 'comment_id', { 
	on_delete => 'no action',
	join_type => 'left',
};

before insert => sub {
	my ( $self ) = @_;
	unless ($self->key) {
		$self->key($self->get_url);
	}
	if ($self->user->ignore) {
		$self->checked($self->ddgc->find_user( $self->ddgc->config->automoderator_account )->id);
	}
};

after insert => sub {
  my ( $self ) = @_;
  $self->user->add_context_notification('forum_comments',$self);
};

after update => sub {
  my ( $self ) = @_;
  $self->add_event('update');
  $self->schema->without_events(sub {
  	if ($self->ghosted != $self->comment->ghosted) {
  		$self->comment->ghosted($self->ghosted);
  	}
  	if (defined $self->checked) {
  		if (defined $self->comment->checked) {
  			$self->comment->checked($self->checked)
  				if $self->comment->checked != $self->checked;
  		} else {
  			$self->comment->checked($self->checked);
  		}
  	}
  	$self->comment->update;
  });
};

sub sorted_screenshots {
	my ( $self ) = @_;
	$self->screenshot_threads->search_related('screenshot',{},{
		sorted_by => [qw( me.created )],
	});
}

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
	return $key || 'url';
}

sub forum_is {
	my ($self, $forum) = @_;
	return ($self->forum eq $self->ddgc->config->id_for_forum($forum));
}

sub user_has_access {
	my ($self, $user) = @_;
	return 1 if (!$self->ddgc->config->forums->{$self->forum}->{user_filter});
	return 1 if ($user && $self->forum_is('special'));
	return $self->ddgc->config->forums->{$self->forum}->{user_filter}->($user);
}

no Moose;
__PACKAGE__->meta->make_immutable;
