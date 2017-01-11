package DDGC::Web::Controller::Forum::My;
# ABSTRACT: Forum user functions

use Moose;
BEGIN { extends 'Catalyst::Controller'; }
with 'DDGC::Web::Role::ScreenshotForm';

use Try::Tiny;

sub base : Chained('/forum/base') PathPart('my') CaptureArgs(0) {
	my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
}

# /forum/my/newthread
sub newthread : Chained('base') Args(1) {
	my ( $self, $c, $forum_id ) = @_;
	$c->response->status(404);
	return $c->detach;
	$c->stash->{forum_index} = $forum_id // 1;
	if (!$c->d->config->forums->{$c->stash->{forum_index}}) {
		$c->response->redirect($c->chained_uri('Forum', 'general'));
		return $c->detach;
	}
	if ($forum_id eq $c->d->config->id_for_forum('special')) {
		$c->response->redirect($c->chained_uri('Forum', 'general'));
		return $c->detach;
	}
	my $user_filter = $c->d->config->forums->{$c->stash->{forum_index}}->{user_filter};
	if ($user_filter && (!$c->user || !$user_filter->($c->user))) {
		$c->response->redirect($c->chained_uri('Forum', 'general'));
		return $c->detach;
	}
	
	$c->add_bc($c->d->config->forums->{$c->stash->{forum_index}}->{name},
		$c->chained_uri(
			'Forum',
			$c->d->config->forums->{$c->stash->{forum_index}}->{url},
	));
	$c->add_bc("New Thread");
	

	$self->screenshot_form($c);

	if ($c->req->params->{post_thread} && (!$c->req->params->{title} || !$c->req->params->{content})) {
		$c->stash->{error} = 'One or more fields were empty.';
	} elsif ($c->req->params->{post_thread}) {
		$c->require_action_token;
		my $thread;
		my $err = 0;
		try {
			$thread = $c->d->forum->add_thread(
			$c->user,
			$c->req->params->{content},
			forum => $c->stash->{forum_index},
			title => $c->req->params->{title},
			defined $c->session->{forms}->{$c->stash->{form_id}}->{screenshots}
				? ( screenshot_ids => $c->session->{forms}->{$c->stash->{form_id}}->{screenshots} )
				: (),
			);
		}
		catch {
			$err = 1;
		};
		if ($err) {
			$c->session->{error_msg} = "We were unable to post your comment. Have you posted already in the last few minutes? If so, please <a href='javascript:history.back()'>go back</a> and try again in a short while.";
			$c->response->redirect($c->chained_uri('Root','error'));
			return $c->detach;
		}
		$c->response->redirect($c->chained_uri(@{$thread->u}));
		return $c->detach;
	}
}

sub thread : Chained('base') CaptureArgs(1) {
	my ( $self, $c, $id ) = @_;
	$c->stash->{thread} = $c->d->rs('Thread')->find($id);
	unless ($c->stash->{thread}) {
		$c->response->redirect($c->chained_uri('Forum','general',{ thread_notfound => 1 }));
		return $c->detach;
	}
	unless ($c->user->is('forum_manager') || $c->stash->{thread}->users_id == $c->user->id) {
		$c->response->redirect($c->chained_uri('Forum','general',{ thread_notallowed => 1 }));
		return $c->detach;
	}
}

sub edit : Chained('thread') Args(0) {
	my ( $self, $c ) = @_;

	$self->screenshot_form($c);

	if ($c->req->params->{post_thread}) {
		$c->require_action_token;

		eval { $c->d->db->txn_do(sub {
			if ($c->req->params->{title} && $c->req->params->{content}) {
				$c->stash->{thread}->data({}) unless $c->stash->{thread}->data;
				$c->stash->{thread}->data->{revisions} = [] unless defined $c->stash->{thread}->data->{revisions};
				push @{$c->stash->{thread}->data->{revisions}}, {
					title => $c->stash->{thread}->title,
					content => $c->stash->{thread}->content,
					updated => $c->stash->{thread}->updated,
					screenshot_ids => [$c->stash->{thread}->sorted_screenshots->ids],
				};
				$c->stash->{thread}->title($c->req->params->{title});
				$c->stash->{thread}->update;
				$c->stash->{thread}->comment->content($c->req->params->{content});
				$c->stash->{thread}->comment->update;
				my @screenshot_ids = $self->screenshot_ids($c);
				$c->stash->{thread}->screenshot_threads->search_rs({
					screenshot_id => { -not_in => [@screenshot_ids] },
				})->delete;
				for (@screenshot_ids) {
					$c->stash->{thread}->find_or_create_related('screenshot_threads',{
						screenshot_id => $_
					},{
						key => 'screenshot_thread_thread_id_screenshot_id'
					});
				}
				$c->d->forum->index(
                                        uri => $c->stash->{thread}->id,
					body => $c->req->params->{content},
                                        title => $c->req->params->{title},
                                        id => $c->stash->{thread}->id,
                                        is_markup => 1,
				);
			} else {
				$c->stash->{error} = 'One or more fields were empty.';
			}
		}) };

		$c->stash->{error} = $@ if $@;

		unless (defined $c->stash->{error}) {
			$c->response->redirect($c->chained_uri(@{$c->stash->{thread}->u},{
				update_successful => 1,
			}));
			return $c->detach;
		}

	}

}

sub delete : Chained('thread') Args(0) {
	my ( $self, $c ) = @_;
	if ($c->req->params->{i_am_sure}) {
		$c->require_action_token;
		my $id = $c->stash->{thread}->id;
                eval { $c->d->forum->search_engine->delete($id . '/' . $c->stash->{thread}->get_url); };
		$c->d->db->txn_do(sub {
			$c->stash->{thread}->delete();
			$c->d->rs('Comment')->search({ context => "DDGC::DB::Result::Thread", context_id => $id })->delete();
		});
		$c->response->redirect($c->chained_uri('Forum','general'));
		return $c->detach;
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
