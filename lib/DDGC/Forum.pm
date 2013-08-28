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

sub comments_grouped { shift->ddgc->rs('Comment')->grouped_by_context }

sub comments_grouped_in { shift->comments_grouped->search({
	context => { -in => [@_] },
}) }

sub context_threads {qw(
	DDGC::DB::Result::Thread
)}
sub comments_grouped_threads { $_[0]->comments_grouped_in(
	$_[0]->context_threads
) }

sub context_translation {qw(
	DDGC::DB::Result::Token::Language
	DDGC::DB::Result::Token::Domain::Language
)}
sub comments_grouped_translation { $_[0]->comments_grouped_in(
	$_[0]->context_translation
) }

sub context_blog {qw(
	DDGC::DB::Result::Blog
)}
sub comments_grouped_blog { $_[0]->comments_grouped_in(
	$_[0]->context_blog
) }

sub add_thread {
	my ( $self, $user, $content, %params ) = @_;

	$self->ddgc->db->txn_do(sub {
		my $thread = $self->ddgc->rs('Thread')->create({
			users_id => $user->id,
			%params,
		});
		my $thread_comment = $self->ddgc->add_comment(
			'DDGC::DB::Result::Thread',
			$thread->id,
			$user,
			$content,
		);
		$thread->comment_id($thread_comment->id);
		$thread->update;
	});
}

sub add_comment_on {
	my ( $self, $object, @args ) = @_;
	my $ref = ref $object;
	die $ref." doesn't support add_comment_on" unless $self->can('id');
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
