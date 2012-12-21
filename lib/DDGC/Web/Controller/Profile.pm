package DDGC::Web::Controller::Profile;
use Moose;
use namespace::autoclean;

use DDGC::Config;
use Dist::Data;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->stash->{title} = 'Profile';
}

sub user :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $username ) = @_;
    $c->stash->{user} = $c->d->find_user($username);
    unless ($c->stash->{user} && $c->stash->{user}->public) {
    	return $c->go('/default');
    }
    $c->add_bc('User Profile', '');
    $c->add_bc($username, '');
}

sub home :Chained('user') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{last_comments} = $c->user->last_comments(1,5);
}

__PACKAGE__->meta->make_immutable;

1;
