package DDGC::Schema::ResultSet::ActivityFeed;

# ABSTRACT: Resultset class for activity feed

use Moo;
extends 'DDGC::Schema::ResultSet';
use List::MoreUtils qw( uniq );

sub for_user {
    my ( $self ) = @_;
    my $user = $self->current_user;

    return $self->search_rs( {
        for_user => { '=' => undef },
        for_role => { '=' => undef },
    } ) if !$user;

    $self->search_rs( {
        for_user => { '=' => [ undef, $user->id ] },
        -or => [
            for_role => { '=' => undef },
            for_role => {
                -in => $user->roles->columns([qw/ id /])->all
            }
        ],
    } );
}

1;
