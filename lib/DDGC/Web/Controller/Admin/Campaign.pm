package DDGC::Web::Controller::Admin::Campaign;

# ABSTRACT: Campaign web controller class

use Moose;
BEGIN { extends 'Catalyst::Controller'; }
use List::MoreUtils qw/ each_array /;
use Try::Tiny;
use namespace::autoclean;

sub base : Chained('/admin/base') : PathPart('campaign') : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    $c->add_bc( 'Campaign', $c->chained_uri( 'Admin::Campaign', 'index' ) );
}

sub index : Chained('base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;
    $c->bc_index;
}

sub bad_user_response : Chained('base') : PathPart('bad_user_response') : Args(0) {
    my ( $self, $c ) = @_;
    $c->add_bc('Bad response');
    ($c->stash->{user}, $c->stash->{campaign}) = ($c->req->params->{user}, $c->req->params->{campaign});

    $c->stash->{campaign_options} = [ map { {
            value => $_,
            text  => $c->d->config->campaigns->{$_}->{id} . ' - ' . $c->d->config->campaigns->{$_}->{name},
        } } keys $c->d->config->campaigns ];

    if ($c->req->params->{save_bad_response}) {
        if (!$c->req->params->{user}) {
            $c->stash->{user_not_supplied} = 1;
            return $c->detach;
        }
        if (!$c->req->params->{campaign}) {
            $c->stash->{campaign_not_selected} = 1;
            return $c->detach;
        }
        my $user = $c->d->find_user($c->req->params->{user});
        if (!$user) {
            $c->stash->{user_not_found} = 1;
            return $c->detach;
        }

        if ($user->set_bad_response($c->stash->{campaign})) {
            $c->stash->{bad_response_success} = 1;
        }
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;

