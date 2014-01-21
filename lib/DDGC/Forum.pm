package DDGC::Forum;
# ABSTRACT: 

use Moose;
use File::ShareDir::ProjectDistDir;
use JSON;
use LWP::Simple;
use URL::Encode 'url_encode_utf8';

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	weak_ref => 1,
	required => 1,
);

sub comments_grouped { shift->ddgc->rs('Comment')->ghostbusted->grouped_by_context->prefetch_all }

sub comments_grouped_in { shift->comments_grouped->search_rs({
	'me.context' => { -in => [@_] },
}) }

sub context_threads {qw(
	DDGC::DB::Result::Thread
)}
sub comments_grouped_threads { $_[0]->comments_grouped_in(
	$_[0]->context_threads
) }

sub context_ideas {qw(
	DDGC::DB::Result::Idea
)}
sub comments_grouped_ideas { $_[0]->comments_grouped_in(
	$_[0]->context_ideas
) }

sub context_translation {qw(
	DDGC::DB::Result::Token::Language
	DDGC::DB::Result::Token::Domain::Language
)}
sub comments_grouped_translation { $_[0]->comments_grouped_in(
	$_[0]->context_translation
) }

sub context_blog {qw(
	DDGC::DB::Result::User::Blog
)}
sub comments_grouped_blog { $_[0]->comments_grouped_in(
	$_[0]->context_blog
) }
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
) }

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
		$thread = $self->ddgc->rs('Thread')->create({
			users_id => $user->id,
			%params,
		});
		$self->ddgc->without_events(sub {
			for (@screenshot_ids) {
				$thread->create_related('screenshot_threads',{
					screenshot_id => $_
				});
			}
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
        my $thread  = $self->ddgc->rs('Thread')->search( { comment_id => $context_id } )->first;
 
        $user->add_context_notification( 'forum_comments', $thread );

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
			})->first;
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
