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
	$c->stash->{avatar} = $c->user->profile_picture(80);
	if ($c->req->param('save_userpage')) {
		$c->require_action_token;
		my @errors = $c->stash->{up}->update_data($c->req->params);
		$c->stash->{userpage_save_errors} = @errors ? 1 : 0;
		$c->stash->{userpage_saved} = 1;
		$c->stash->{up}->update;
	}
	if ($c->req->param('avatar')) {
		$c->user->set_avatar($c->req->uploads->{avatar});
	}
	elsif ($c->req->param('delete_avatar')) {
		$c->user->delete_avatar;
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
