package DDGC::DB::Result::Idea;
# ABSTRACT: DuckDuckHack Instant Answer Plugin

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'idea';

sub u { [ 'Ideas', 'idea', $_[0]->id, $_[0]->key ] }

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column claimed_by => {
	data_type => 'bigint',
	is_nullable => 0,
};

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column key => {
	data_type => 'text',
	is_nullable => 0,
	indexed => 1,
};

column title => {
	data_type => 'text',
	is_nullable => 0,
};

column content => {
	data_type => 'text',
	is_nullable => 0,
};
sub html { ( $_[0]->data && $_[0]->data->{is_html} ) ? $_[0]->content :  $_[0]->ddgc->markup->html($_[0]->content) }

column source => {
	data_type => 'text',
	is_nullable => 1,
};
sub source_html { $_[0]->source ? $_[0]->ddgc->markup->html($_[0]->source) : "" }

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

sub types {{
	0 => "I don't know...",
	1 => "Fathead (keyword data)",
	2 => "Goodie (Perl functions)",
	3 => "Spice (API calls)",
	4 => "Longtail (full-text data)",
	5 => "Internal",
}}

sub type_name { $_[0]->types->{$_[0]->type} }

column type => {
	data_type => 'int',
	default_value => 0,
};

sub statuses {{
	0 => "New",
	1 => "Needs More Definition",
	2 => "Needs Source Suggestions",
	3 => "Needs a Developer",
	4 => "In Development",
	5 => "Under Review",
	6 => "On Hold",
	7 => "Duplicate",
	8 => "Live",
	9 => "Not an Instant Answer idea",
	10 => "Improvement",
	11 => "Declined",
}}

sub status_name { $_[0]->statuses->{$_[0]->status} }

sub status_colors {{
	1 => "#5b5f68",
	2 => "#f09450",
	3 => "#d84736",
	4 => "#4b8df8",
	5 => "#3eb8b4",
	6 => "#6b7b94",
	7 => "#999999",
	8 => "#48af04",
	9 => "#af5d9c",
	10 => "#d83677",
	11 => "#9e8b75",
}}

sub status_color { $_[0]->status_colors->{$_[0]->status} }

column status => {
	data_type => 'int',
	default_value => 0,
};

column old_vote_count => {
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

column old_url => {
	data_type => 'text',
	is_nullable => 1,
};

column migrated_to_thread => {
	data_type => 'bigint',
	is_nullable => 1,
};

__PACKAGE__->add_antispam_functionality;

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';

belongs_to 'user', 'DDGC::DB::Result::User', 'claimed_by';

has_many 'idea_votes', 'DDGC::DB::Result::Idea::Vote', 'idea_id', {
	cascade_delete => 1,
};

has_many 'github_pulls', 'DDGC::DB::Result::GitHub::Pull', 'idea_id', {
	cascade_delete => 0,
};

sub vote_count {
	my ( $self ) = @_;
	return $self->get_column('total_vote_count') if $self->has_column_loaded('total_vote_count');
	return $self->old_vote_count + $self->idea_votes->count;
}

sub user_voted {
	my ( $self, $user ) = @_;
	return $self->search_related('idea_votes',{
		users_id => $user->db->id,
	})->count;
}

after insert => sub {
	my ( $self ) = @_;
	$self->user->add_context_notification('forum_comments',$self);
	$self->user->add_context_notification('idea_votes',$self);
};

after update => sub {
	my ( $self ) = @_;
	$self->add_event('update');
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

sub set_user_vote {
	my ( $self, $user, $vote ) = @_;
	return if $user->id == $self->user->id;
	if ($vote) {
		my $voted = $self->search_related('idea_votes',{
			users_id => $user->id,
		})->first;
		unless ($voted) {
			$self->create_related('idea_votes',{
				users_id => $user->id,
			});
		}
	} else {
		$self->search_related('idea_votes',{
			users_id => $user->id,
		})->delete;
	}
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

sub migrate_to_ramblings {
	my ( $self ) = @_;
	return undef if $self->migrated_to_thread;

	my $comment = $self->content . ( ($self->source) ?
		  "\n\nSource:\n\n" . $self->source
		: ""
	);

	my $data = $self->data;
	$data->{migrated_from_idea} = $self->id;
	my $thread = $self->ddgc->forum->add_thread(
		$self->user,
		$comment,
		forum => $self->ddgc->config->id_for_forum('general'),
		title => $self->title,
		data  => $data,
		created => $self->ddgc->db->format_datetime( $self->created ),
		updated => $self->ddgc->db->format_datetime( $self->updated ),
		ghosted => $self->ghosted,
		checked => $self->checked,
		old_url => $self->old_url,
		seen_live => $self->seen_live,
	);
	
	return undef unless $thread;

	while (my $comment = $self->comments->next) {
		$comment->update({
			context => 'DDGC::DB::Result::Thread',
			context_id => $thread->id,
			parent_id => $comment->parent_id || $thread->comment->id,
		});
	}

	$self->migrated_to_thread($thread->id);
	$self->update;

	return $thread;
}

no Moose;
__PACKAGE__->meta->make_immutable;
