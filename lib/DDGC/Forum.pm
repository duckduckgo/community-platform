package DDGC::Forum;
# ABSTRACT: 

use Moose;
use File::ShareDir::ProjectDistDir;
use JSON;
use LWP::Simple;
use URL::Encode 'url_encode_utf8';
use DDGC::Search::Client;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	weak_ref => 1,
	required => 1,
);

has index_name => (
	is => 'ro',
	default => sub { 'thread' },
);

with 'DDGC::Role::Searchable';

sub comments_grouped { shift->ddgc->rs('Comment')->ghostbusted->grouped_by_context->search(
		{}, { prefetch => [ qw/ user / ], },
	);
}

sub comments_grouped_in { shift->comments_grouped->search_rs({
	'me.context' => { -in => [@_] },
}) }

sub context_threads {qw(
	DDGC::DB::Result::Thread
)}
sub comments_grouped_threads {
	$_[0]->comments_grouped_in(
		$_[0]->context_threads
	)->search({ 'thread.migrated_to_idea' => undef }, { prefetch => { thread => 'user' } })
}
sub comments_grouped_general_threads{
		$_[0]->comments_grouped_threads->search_rs({ 'thread.forum' => 1 });
}
sub comments_grouped_community_leaders_threads{
		$_[0]->comments_grouped_threads->search_rs({ 'thread.forum' => 2 });
}
sub comments_grouped_admin_threads{
		$_[0]->comments_grouped_threads->search_rs({ 'thread.forum' => 4 });
}
sub comments_grouped_special_threads{
		$_[0]->comments_grouped_threads->search_rs({ 'thread.forum' => 5 });
}

sub context_ideas {qw(
	DDGC::DB::Result::Idea
)}
sub comments_grouped_ideas { $_[0]->comments_grouped_in(
		$_[0]->context_ideas
	)->prefetch_all;
}

sub allow_user {
  my ( $self, $forum_index, $user ) = @_;
  my $user_filter = $self->ddgc->config->forums->{$forum_index}->{user_filter};
  return 0 if ($user_filter && (!$user || !$user_filter->($user)));
  return 1;
}
sub forbidden_forums {
	my ($self, $user) = @_;
	return grep {
		!$self->allow_user( $_, $user )
	} keys $self->ddgc->config->forums;
}

sub context_translation {qw(
	DDGC::DB::Result::Token::Language
	DDGC::DB::Result::Token::Domain::Language
)}
sub comments_grouped_translation { $_[0]->comments_grouped_in(
	$_[0]->context_translation
)->prefetch_all }

sub context_blog {qw(
	DDGC::DB::Result::User::Blog
)}
sub comments_grouped_blog { $_[0]->comments_grouped_in(
		$_[0]->context_blog
	)->search({}, { prefetch => { user_blog => 'user' } });
}
sub comments_grouped_company_blog {
	$_[0]->comments_grouped_blog->search_rs({ 'user_blog.company_blog' => 1 })
}
sub comments_grouped_user_blog {
	$_[0]->comments_grouped_blog->search_rs({ 'user_blog.company_blog' => 0 })
}

sub comments_grouped_not_in { shift->comments_grouped->search_rs({
	'me.context' => { -not_in => [@_] },
}) }
sub comments_grouped_other { $_[0]->comments_grouped_not_in(
	$_[0]->context_blog,
	$_[0]->context_translation,
	$_[0]->context_threads,
)->prefetch_all }
sub comments_grouped_for_user {
	my ( $self, $user ) = @_;
	my @forbidden_forums = $self->forbidden_forums($user);

	my $comments_grouped_rs = (@forbidden_forums) ?
	$self->comments_grouped->search_rs( {
		'me.id' => {
			-not_in =>
				$self->comments_grouped_threads->search_rs( {
					'thread.forum' => \@forbidden_forums
				} )->get_column('id')->as_query
		}
	} ) :
	$self->comments_grouped;
	return $comments_grouped_rs->prefetch_all;
}
sub user_comments_threads {
	my ( $self, $user ) = @_;
	$self->ddgc->rs('Comment')->search_rs({
			'me.context' => context_threads,
			'me.users_id' => $user->id,
	})->prefetch_all;
}
sub user_comments_for_user {
	my ( $self, $c ) = @_;
	my @forbidden_forums = $self->forbidden_forums($c->user);

	return (@forbidden_forums) ?
	$c->stash->{user}->last_comments->search_rs( {
		'me.id' => {
			-not_in =>
				$self->user_comments_threads($c->stash->{user})->search_rs( {
					'thread.forum' => \@forbidden_forums
				} )->get_column('id')->as_query
		}
	} ) :
	$c->stash->{user}->last_comments;
}
sub threads_for_user {
	my ( $self, $user ) = @_;
	my @forbidden_forums = $self->forbidden_forums($user);

	return (@forbidden_forums) ?
	$self->ddgc->rs('Thread')->ghostbusted->search_rs( {
		'me.forum' => { '-not_in' => \@forbidden_forums }
	} ) :
	$self->ddgc->rs('Thread');
}

sub comments {
	my ( $self, $context, $context_id ) = @_;
	if (ref $context) {
		$context_id = $context->id;
		$context = ref $context;
	}
	$self->ddgc->rs('Comment')->search_rs({
		context => $context,
		context_id => $context_id,
		parent_id => 0,
	})->prefetch_tree;
}

sub add_thread {
	my ( $self, $user, $content, %params ) = @_;

	my $thread;

	$self->ddgc->db->txn_do(sub {
		my @screenshot_ids;
		push @screenshot_ids, @{delete $params{screenshot_ids}} if defined $params{screenshot_ids};
		my %comment_params = defined $params{comment_params}
			? (%{delete $params{comment_params}})
			: ();
		my $forum = delete $params{forum} // 1;
		$thread = $self->ddgc->rs('Thread')->create({
			users_id => $user->id,
			forum => $forum,
			%params,
		});
		$self->ddgc->without_events(sub {
			for (@screenshot_ids) {
				$thread->create_related('screenshot_threads',{
					screenshot_id => $_
				});
			}
			$comment_params{created} = $self->ddgc->db->format_datetime( $thread->created ),
			$comment_params{updated} = $self->ddgc->db->format_datetime( $thread->created ),
			my $thread_comment = $self->ddgc->add_comment(
				'DDGC::DB::Result::Thread',
				$thread->id,
				$user,
				$content,
				%comment_params,
			);
			$thread->comment_id($thread_comment->id);
			$thread->update;
		});

		$self->index(
			title => $thread->title,
			uri => $thread->id,
			body => $content,
			id => $thread->id,
			is_markup => 1,
		);
	});

	return $thread;
}

sub add_comment_on {
	my ( $self, $object, @args ) = @_;
	my $ref = ref $object;
	die $ref." doesn't support add_comment_on" unless $object->can('id');
	$self->add_comment($ref, $object->id, @args);
}

sub add_comment {
	my ( $self, $context, $context_id, $user, $content, @args ) = @_;
	
	if ( $context eq 'DDGC::DB::Result::Comment' ) {
		my $comment = $self->ddgc->rs('Comment')->find($context_id);
		return $self->ddgc->rs('Comment')->create({
			context => $comment->context,
			context_id => $comment->context_id,
			parent_id => $context_id,
			users_id => $user->id,
			content => $content,
			@args,
		});
	} else {
		if ($context eq 'DDGC::DB::Result::Thread') {
			my $thread_comment = $self->ddgc->rs('Comment')->search_rs({
				context => 'DDGC::DB::Result::Thread',
				context_id => $context_id,
				parent_id => undef,
			})->one_row;
			if ($thread_comment) {
				return $self->add_comment(
					'DDGC::DB::Result::Comment',
					$thread_comment->id,
					$user,
					$content,
					@args
				);
			}
		}
		return $self->ddgc->rs('Comment')->create({
			context => $context,
			context_id => $context_id,
			users_id => $user->id,
			content => $content,
			@args,
		});
	}
}

1;
