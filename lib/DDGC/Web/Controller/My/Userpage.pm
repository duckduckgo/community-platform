package DDGC::Web::Controller::My::Userpage;
# ABSTRACT: Userpage editor

use Moose;
BEGIN {extends 'Catalyst::Controller'; }

use DateTime;
use namespace::autoclean;

sub base :Chained('/my/logged_in') :PathPart('userpage') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('Userpage Editor', $c->chained_uri('My::Userpage','index'));
	$c->stash->{up} = $c->user->userpage_obj;

	if ($c->req->param('save_userpage')) {
		$c->require_action_token;
		my @errors = $c->stash->{up}->update_data($c->req->params);
		$c->stash->{userpage_save_errors} = @errors ? 1 : 0;
		$c->stash->{userpage_saved} = 1;
		$c->stash->{up}->update;
		$c->user->set_avatar;
        $c->user->update({ github_user => $c->req->params->{github} }) if $c->req->params->{github};
	}

	if ($c->user->profile_picture(80)) {
		push @{$c->stash->{avatars}}, { name => 'current', media_url => $c->user->profile_picture(80), avatar_id => 'current' }
	};
	push @{$c->stash->{avatars}}, $c->user->reload_stash;

	if ($c->req->param('avatar')) {
		my $stash = $c->user->stash_avatar($c->req->uploads->{avatar});
		if (!$stash->{success}) {
			$c->res->code(400);
			$c->stash->{x} = {
				error => $stash->{msg},
			};
			return $c->forward('View::JSON');
		}

		$c->stash->{x} = {
			avatar_id => $c->req->uploads->{avatar}->filename,
		};
		$c->forward('View::JSON');
	}
	elsif ($c->req->param('delete_avatar')) {
		$c->user->queue_delete_avatar($c->req->param('filename'));
	}
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;
	$c->stash->{fields} = $c->stash->{up}->attribute_fields;
}

sub json :Chained('base') :Args(0) {
	my ( $self, $c ) = @_;
	$c->stash->{x} = $c->stash->{up}->export;
	$c->forward('View::JSON');
}


__PACKAGE__->meta->make_immutable;

1;
