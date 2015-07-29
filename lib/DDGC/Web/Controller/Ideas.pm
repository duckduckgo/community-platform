package DDGC::Web::Controller::Ideas;
# ABSTRACT: Idea controller

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('ideas') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	push @{$c->stash->{template_layout}}, 'ideas/base.tx';
	$c->stash->{title} = 'Instant Answer Ideas';
	$c->add_bc('Instant Answer Ideas',$c->chained_uri('Ideas','index'));
	my $idea_types = $c->d->rs('Idea')->result_class->types;
	my $idea_statuses = $c->d->rs('Idea')->result_class->statuses;
	$c->stash->{page_class} = "page-ideas texture";
	$c->stash->{idea_types} = [map { [ $_, $idea_types->{$_} ] } sort { $a <=> $b } keys %{$idea_types}];
	$c->stash->{idea_statuses} = [map { [ $_, $idea_statuses->{$_} ] } sort { $a <=> $b } keys %{$idea_statuses}];
	$c->stash->{ideas_rs} = $c->d->rs('Idea')->search_rs({
			migrated_to_thread => undef,
		},{
		prefetch => [qw( user ),{
			idea_votes => [qw( user )],
		}]
	})->ghostbusted;
}

sub add_latest_ideas {
	my ( $self, $c ) = @_;
	$c->stash->{latest_ideas} = [ $c->d->rs('Idea')->ghostbusted->search_rs({
			migrated_to_thread => undef,
		},{
		order_by => { -desc => 'me.created' },
		rows => 5,
		page => 1,
	})->all ];
}

sub add_ideas_table {
	my ( $self, $c, @args ) = @_;
	$c->stash->{ideas} = $c->table(
		$c->stash->{ideas_rs}->add_vote_count,['Ideas',@args],[],
		default_pagesize => 15,
		default_sorting => defined $c->stash->{idea_order} ? 'id' : '-me.updated',
		id => 'idealist_'.join('_',grep { ref $_ eq '' } @args),
		sorting_options => [{
			label => 'Votes',
			sorting => 'votes',
			order_by => { -desc => $c->stash->{ideas_rs}->correlated_total_vote_count },
		},{
			label => 'Last Update',
			sorting => '-me.updated',
		},defined $c->stash->{idea_order} ? {
                        label => 'Relevancy',
                        sorting => 'id',
                        order_by => { -desc => $c->stash->{idea_order} },
                }:()],
	);
}

sub newidea : Chained('base') Args(0) {
	my ( $self, $c ) = @_;
	$self->add_latest_ideas($c);
	$c->stash->{title} = 'New Instant Answer Idea';
	$c->add_bc('New Instant Answer Idea');
	if ($c->req->params->{save_idea} && (!$c->req->params->{title} || !$c->req->params->{content})) {
		$c->stash->{error} = 'One or more fields were empty.';
	} elsif ($c->req->params->{save_idea}) {
		my $idea = $c->user->create_related('ideas',{
			title => $c->req->params->{title},
			content => $c->req->params->{content},
			source => $c->req->params->{source},
			type => $c->req->params->{type},
			data => {},
		});
		$c->d->idea->index(
			uri => $idea->id,
			title => $idea->title,
			body => $idea->content,
			id => $idea->id,
			is_markup => 1,
		);
		$c->response->redirect($c->chained_uri(@{$idea->u}));
		return $c->detach;
	}
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$self->add_ideas_table($c,'index');
	$c->bc_index;
}

sub search : Chained('base') Args(0) {
	my ( $self, $c ) = @_;

	$c->add_bc('Search');

	$c->stash->{query} = $c->req->params->{q};
	return unless length($c->stash->{query});

        my ($ideas, $ideas_rs, $order) = $c->d->idea->search_engine->rs(
            $c,
            $c->stash->{query},
            $c->d->rs('Idea')->ghostbusted,
        );

        $c->stash->{ideas_rs} = $ideas_rs;
        $c->stash->{idea_order} = $order;
	$self->add_ideas_table($c,'search',{ q => $c->stash->{query} }) if defined $ideas_rs;
}

sub type :Chained('base') :Args(1) {
	my ( $self, $c, $type ) = @_;
	$c->stash->{ideas_rs} = $c->stash->{ideas_rs}->search_rs({
		type => $type,
	});
	$self->add_ideas_table($c,'type',$type);
	$self->add_latest_ideas($c);
	$c->add_bc('Filtered');
}

sub status :Chained('base') :Args(1) {
	my ( $self, $c, $status ) = @_;
	$c->stash->{ideas_rs} = $c->stash->{ideas_rs}->search_rs({
		status => $status,
	});
	$self->add_ideas_table($c,'status',$status);
	$self->add_latest_ideas($c);
	$c->add_bc('Filtered');
}

sub idea_id : Chained('base') PathPart('idea') CaptureArgs(1) {
	my ( $self, $c, $id ) = @_;
	$c->stash->{idea} = $c->d->rs('Idea')->find($id);

	unless ($c->stash->{idea}) {
		$c->response->redirect($c->chained_uri('Ideas','index',{ idea_notfound => 1 }));
		return $c->detach;
	}

	if ($c->stash->{idea}->ghosted && $c->stash->{idea}->checked &&
	   (!$c->user || (!$c->user->admin && $c->stash->{idea}->users_id != $c->user->id))) {
		$c->response->redirect($c->chained_uri('Ideas','index',{ idea_notfound => 1 }));
	}

	if ($c->stash->{idea}->migrated_to_thread) {
		$c->response->redirect($c->chained_uri('Forum','thread',$c->stash->{idea}->migrated_to_thread));
		return $c->detach;
	}

	$c->add_bc($c->stash->{idea}->title,$c->chained_uri(@{$c->stash->{idea}->u}));
	$self->add_latest_ideas($c);
}

sub idea_redirect : Chained('idea_id') PathPart('') Args(0) {
	my ( $self, $c ) = @_;
	$c->response->redirect($c->chained_uri(@{$c->stash->{idea}->u}));
	return $c->detach;
}

sub idea : Chained('idea_id') PathPart('') Args(1) {
	my ( $self, $c, $key ) = @_;
	$c->bc_index;
	if ($c->user && $c->user->is('idea_manager') && $c->req->params->{change_status}) {
		$c->stash->{idea}->status($c->req->params->{status});
		$c->stash->{idea}->update;
		if ( lc($c->stash->{idea_statuses}->[ $c->req->params->{status} ]->[1])
		     eq 'not an instant answer idea') {
			my $thread = $c->stash->{idea}->migrate_to_ramblings;
			if ($thread) {
				$c->response->redirect($c->chained_uri('Forum','thread',$thread->id,$thread->key));
				return $c->detach;
			}
		}
	}
	if ($c->user && $c->req->params->{unfollow}) {
		$c->require_action_token;
		$c->user->delete_context_notification($c->req->params->{unfollow},$c->stash->{idea});
	} elsif ($c->user && $c->req->params->{follow}){
		$c->require_action_token;
		$c->user->add_context_notification($c->req->params->{follow},$c->stash->{idea});
	}
	unless ($c->stash->{idea}->key eq $key) {
		$c->response->redirect($c->chained_uri(@{$c->stash->{idea}->u}));
		return $c->detach;
	}
	$c->stash->{title} = $c->stash->{idea}->title;
}

sub claim : Chained('idea_id') Args(0) {
	my ( $self, $c ) = @_;
	$c->require_action_token;
	return $c->detach if (!$c->user);

	if ( !$c->stash->{idea}->claimed_by ) {
		$c->stash->{idea}->update( {
			claimed_by => $c->user->id,
		} );
	}
	elsif ( $c->stash->{idea}->claimed_by &&
	     ( $c->stash->{idea}->claimed_by == $c->user->id ||
	       $c->user->is('forum_manager') ) ) {
		$c->stash->{idea}->update( {
			claimed_by => undef,
		} );
	}
	$c->response->redirect( $c->chained_uri(@{ $c->stash->{idea}->u }) );
}

sub delete : Chained('idea_id') Args(0) {
	my ( $self, $c ) = @_;
	unless ($c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
	unless ($c->user->id == $c->stash->{idea}->users_id || $c->user->is('idea_manager')) {
		$c->response->redirect($c->chained_uri(@{$c->stash->{idea}->u}));
		return $c->detach;
	}
	my $id = $c->stash->{idea}->id;
        eval { $c->d->idea->search_engine->delete(@{$c->stash->{idea}->u}[-2,-1]); };
	$c->d->db->txn_do(sub {
		$c->stash->{idea}->delete();
		$c->d->rs('Comment')->search({ context => "DDGC::DB::Result::Idea", context_id => $id })->delete();
	});
	$c->response->redirect($c->chained_uri('Ideas','index'));
	return $c->detach;
}

sub edit : Chained('idea_id') Args(0) {
	my ( $self, $c ) = @_;
	unless ($c->user) {
		$c->response->redirect($c->chained_uri('My','login'));
		return $c->detach;
	}
	unless ($c->user->id == $c->stash->{idea}->users_id || $c->user->is('idea_manager')) {
		$c->response->redirect($c->chained_uri(@{$c->stash->{idea}->u}));
		return $c->detach;
	}
	if ($c->req->params->{save_idea} && (!$c->req->params->{title} || !$c->req->params->{content})) {
		$c->stash->{error} = 'One or more fields were empty.';
	} elsif ($c->req->params->{save_idea}) {
		$c->stash->{idea}->data({}) unless $c->stash->{idea}->data;
		$c->stash->{idea}->data->{revisions} = [] unless defined $c->stash->{idea}->data->{revisions};
		push @{$c->stash->{idea}->data->{revisions}}, {
			title => $c->stash->{idea}->title,
			content => $c->stash->{idea}->content,
			source => $c->stash->{idea}->source,
			updated => $c->stash->{idea}->updated,
		};
		if ($c->user->is('idea_manager')) {
			$c->stash->{idea}->type($c->req->params->{type});
		}
		$c->stash->{idea}->title($c->req->params->{title});
		$c->stash->{idea}->content($c->req->params->{content});
		$c->stash->{idea}->source($c->req->params->{source});
		$c->stash->{idea}->update;
		$c->d->idea->index(
			uri => $c->stash->{idea}->id,
			title => $c->stash->{idea}->title,
			body => $c->stash->{idea}->content,
			id => $c->stash->{idea}->id,
			is_markup => 1,
		);
		$c->response->redirect($c->chained_uri(@{$c->stash->{idea}->u}));
		return $c->detach;
	}
	$c->stash->{title} = 'Edit '.$c->stash->{idea}->title;
	$c->add_bc('Edit');
}

sub vote :Chained('idea_id') :CaptureArgs(1) {
	my ( $self, $c, $vote ) = @_;
	$c->require_action_token;
	$c->stash->{idea}->set_user_vote($c->user,0+$vote);
}

sub vote_view :Chained('vote') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{x} = {
		vote_count => $c->stash->{idea}->vote_count
	};
	$c->forward( $c->view('JSON') );
}

no Moose;
__PACKAGE__->meta->make_immutable;
