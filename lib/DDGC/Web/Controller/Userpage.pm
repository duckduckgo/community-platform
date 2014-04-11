package DDGC::Web::Controller::Userpage;
# ABSTRACT: Userpage web controller class

use Moose;
BEGIN {extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base :Chained('/base') :PathPart('user') :CaptureArgs(1) {
	my ( $self, $c, $username ) = @_;
	$c->stash->{userpage_given_user} = $username;
	$c->stash->{user} = $c->d->find_user($username);
	unless ($c->stash->{user} && $c->stash->{user}->public) {
		return $c->go('/default');
	}
}

sub user :Chained('base') :PathPart('') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	my $username = $c->stash->{user}->username;
	$c->add_bc($username, $c->chained_uri('Userpage','home',$username));
	$c->stash->{up} = $c->stash->{user}->userpage_obj;
	$c->stash->{userpage_home} = 1;
	$c->stash->{fields} = $c->stash->{up}->attribute_fields;
	$c->stash->{x} = $c->stash->{up}->export;
	$c->stash->{x}->{username} = $username;
	$c->stash->{title} = $username." User Page";
}

sub home :Chained('user') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;
        my $rs = $c->stash->{user}->last_comments;
        $c->stash->{comments} = $c->table(
            $rs,['Userpage','home',$c->stash->{user}->username],[],
            default_pagesize => 10,
            default_sorting => '-me.updated',
            id => 'userpage_'.$c->stash->{user}->username,
        );
	unless ($c->stash->{user}->username eq $c->stash->{userpage_given_user}) {
		$c->response->redirect($c->chained_uri('Userpage','home',$c->stash->{user}->username));
		return $c->detach;
	}
}

sub json :Chained('user') :Args(0) {
  my ( $self, $c ) = @_;
	$c->stash->{not_last_url} = 1;
	$c->forward('View::JSON');
}

no Moose;
__PACKAGE__->meta->make_immutable;
