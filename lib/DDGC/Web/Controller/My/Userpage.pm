package DDGC::Web::Controller::My::Userpage;
use Moose;
use namespace::autoclean;
use DDGC::User::Page;

use DateTime;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/my/base') :PathPart('userpage') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	$c->add_bc('Userpage Editor', $c->chained_uri('My::Userpage','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->bc_index;
    $c->stash->{up} = DDGC::User::Page->new_from_user($c->user);
    if ($c->req->param('save_userpage')) {
		my @errors = $c->stash->{up}->update_data($c->req->params);
        $c->stash->{userpage_save_errors} = @errors ? 1 : 0;
        $c->stash->{userpage_saved} = 1;
		$c->stash->{up}->update;
    }
    $c->stash->{fields} = $c->stash->{up}->attribute_fields;
}

__PACKAGE__->meta->make_immutable;

1;
