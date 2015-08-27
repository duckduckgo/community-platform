package DDGC::DB::Result::Thread;
# ABSTRACT: Dukgo.com Forum thread

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
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

column migrated_to_idea => {
	data_type => 'bigint',
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

sub migrate_to_ideas {
	my ( $self ) = @_;
	return undef if $self->migrated_to_idea;

	my $data = $self->data;
	$data->{migrated_from_thread} = $self->id;
	$data->{is_html} = $self->comment->is_html;
	my $idea = $self->user->create_related('ideas',{
		title => $self->title,
		data  => $data,
		content => $self->comment->content,
		created => $self->ddgc->db->format_datetime( $self->created ),
		updated => $self->ddgc->db->format_datetime( $self->updated ),
		ghosted => $self->ghosted,
		checked => $self->checked,
		old_url => $self->old_url,
		seen_live => $self->seen_live,
	});

	return undef unless $idea;

	$self->ddgc->idea->index(
		uri => $idea->id,
		title => $idea->title,
		body => $idea->content,
		id => $idea->id,
		is_markup => 1,
	);

	while (my $comment = $self->comments->next) {
		$comment->update({
			context => 'DDGC::DB::Result::Idea',
			context_id => $idea->id,
			parent_id => ($comment->parent_id eq $self->comment->id) ? undef : $comment->parent_id,
		});
	}

	$self->migrated_to_idea($idea->id);
	$self->update;

	return $idea;
}

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
