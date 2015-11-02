package DDGC::Web::Controller::Admin::Campaign;

# ABSTRACT: Campaign web controller class

use Moose;
BEGIN { extends 'Catalyst::Controller'; }
use List::MoreUtils qw/ uniq /;
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
    $c->stash->{user} = $c->req->params->{user};
    $c->stash->{multi_user} = $c->req->params->{multi_user};
    $c->stash->{campaign} = $c->req->params->{campaign} // $c->d->config->first_active_campaign;
    my $user = $c->d->find_user($c->req->params->{user});
    my $response = $user->responded_campaign( $c->stash->{campaign} ) if $user;
    $c->stash->{already_bad} = 1 if ( $response && $response->bad_response );

    if (!$c->stash->{user}) {
        $c->stash->{no_user} = 1;
    }
    if (!$c->stash->{campaign}) {
        $c->stash->{no_campaign} = 1;
        return $c->detach;
    }
    if ($c->req->params->{save_bad_response}) {
        my @usernames = uniq grep { $_ } split /[^a-zA-Z0-9_\.]+/, $c->req->params->{multi_user};
        ($c->req->params->{user}) && push @usernames, $c->req->params->{user};

        for my $username (@usernames) {
            my $user = $c->d->find_user($username);
            if (!$user) {
                push @{ $c->stash->{ users_not_found } }, $username;
            }
            else {
                if ($user->responded_campaign( $c->stash->{campaign} )) {
                    $user->set_bad_response($c->stash->{campaign});
                }
                else {
                    push @{ $c->stash->{ users_not_responded } }, $username;
                }
            }
        }

        if (!$c->stash->{ users_not_found } && !$c->stash->{ users_not_responded }) {
            $c->stash->{bad_response_success} = 1;
        }
        $c->stash->{ multi_user } = join ', ',
            (( $c->stash->{ users_not_responded } ) ?
                @{ $c->stash->{ users_not_responded } } : (),
            ( $c->stash->{ users_not_found } ) ?
                @{ $c->stash->{ users_not_found } } : ())
    }
    if ($c->req->params->{save_good_response}) {
        my $user = $c->d->find_user($c->stash->{user});
        if (!$user) {
            push @{ $c->stash->{ users_not_found } }, $c->stash->{user};
        }
        elsif ($user->responded_campaign( $c->stash->{campaign} )) {
            $user->set_good_response($c->stash->{campaign});
        }
        else {
            push @{ $c->stash->{ users_not_responded } }, $c->stash->{user};
        }
        if (!$c->stash->{ users_not_found } && !$c->stash->{ users_not_responded }) {
            $c->stash->{bad_response_success} = 1;
        }
     }
}

no Moose;
__PACKAGE__->meta->make_immutable;

