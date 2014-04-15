package DDGC::Web::Controller::Forum::My;
# ABSTRACT: Forum user functions

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

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
	$c->stash->{forum_index} = $forum_id // 1;
	if (!$c->stash->{ddgc_config}->forums->{$c->stash->{forum_index}}) {
		$c->response->redirect($c->chained_uri('Forum', 'general'));
		return $c->detach;
	}
	my $user_filter = $c->stash->{ddgc_config}->forums->{$c->stash->{forum_index}}->{user_filter};
	if ($user_filter && (!$c->user || !$user_filter->($c->user))) {
		$c->response->redirect($c->chained_uri('Forum', 'general'));
		return $c->detach;
	}
	
	$c->add_bc($c->stash->{ddgc_config}->forums->{$c->stash->{forum_index}}->{name},
		$c->chained_uri(
			'Forum',
			$c->stash->{ddgc_config}->forums->{$c->stash->{forum_index}}->{url},
	));
	$c->add_bc("New Thread");
	

	$self->thread_form($c);

	if ($c->req->params->{post_thread} && (!$c->req->params->{title} || !$c->req->params->{content})) {
		$c->stash->{error} = 'One or more fields were empty.';
	} elsif ($c->req->params->{post_thread}) {
		$c->require_action_token;
		my $thread = $c->d->forum->add_thread(
			$c->user,
			$c->req->params->{content},
			forum => $c->stash->{forum_index},
			title => $c->req->params->{title},
			defined $c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots}
				? ( screenshot_ids => $c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots} )
				: (),
		);
		$c->response->redirect($c->chained_uri(@{$thread->u}));
		return $c->detach;
	}
}

sub thread_form {
	my ( $self, $c ) = @_;
	$c->stash->{thread_form_id} = $c->req->param('thread_form_id') || $c->next_form_id;
	$c->session->{thread_forms} = {} unless defined $c->session->{thread_forms};
	$c->session->{thread_forms}->{$c->stash->{thread_form_id}} = {}
		unless defined $c->session->{thread_forms}->{$c->stash->{thread_form_id}};
	if ($c->req->param('screenshot')) {
		my $upload = $c->req->uploads->{screenshot};
		my $media = $c->d->rs('Media')->create_via_file($c->user->db, $upload->tempname,{
			upload_filename => $upload->filename,
			content_type => $upload->type
		});
		my $screenshot = $c->d->rs('Screenshot')->create({
			media_id => $media->id,
		});
		$c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots} = []
			unless defined $c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots};
		push @{$c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots}},
			$screenshot->id;
		$c->stash->{x} = {
			screenshot_id => $screenshot->id,
			media_url => $media->url,
		};
		$c->forward('View::JSON');
	} elsif ($c->req->param('delete_screenshot')) {
		my $delete_id = $c->req->param('delete_screenshot');
		$c->stash->{x} = {
			screenshot_id => $delete_id
		};
		my $screenshot = $c->d->rs('Screenshot')->find($delete_id);
		$screenshot->media->delete
			if $screenshot->media->users_id == $c->user->id || $c->user->admin;
		my @old_ids = @{$c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots}};
		my @new_ids;
		for (@old_ids) {
			push @new_ids, $_ unless $_ == $delete_id;
		}
		$c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots} = [@new_ids];
		$c->forward('View::JSON');
	} else {
		my @screenshot_ids;
		if (defined $c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots}) {
			@screenshot_ids = @{$c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots}};
		} elsif (defined $c->stash->{thread}) {
			@screenshot_ids = $c->stash->{thread}->sorted_screenshots->ids;
			$c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots} = [@screenshot_ids];
		}
		$c->stash->{screenshots} = $c->d->rs('Screenshot')->search({
			id => { -in => [@screenshot_ids] },
		});
	}
}

sub thread : Chained('base') CaptureArgs(1) {
	my ( $self, $c, $id ) = @_;
	$c->stash->{thread} = $c->d->rs('Thread')->find($id);
	unless ($c->stash->{thread}) {
		$c->response->redirect($c->chained_uri('Forum','index',{ thread_notfound => 1 }));
		return $c->detach;
	}
	unless ($c->user->admin || $c->stash->{thread}->users_id == $c->user->id) {
		$c->response->redirect($c->chained_uri('Forum','index',{ thread_notallowed => 1 }));
		return $c->detach;
	}
}

sub edit : Chained('thread') Args(0) {
	my ( $self, $c ) = @_;

	$self->thread_form($c);

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
				my @screenshot_ids;
				if (defined $c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots}) {
					@screenshot_ids = @{$c->session->{thread_forms}->{$c->stash->{thread_form_id}}->{screenshots}};
				}
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
		$c->response->redirect($c->chained_uri('Forum','index'));
		return $c->detach;
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
