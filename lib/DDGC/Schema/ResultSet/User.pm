package DDGC::Schema::ResultSet::User;

# ABSTRACT: Resultset class for users

use Moo;
use DateTime;
extends 'DDGC::Schema::ResultSet';

sub unsent_activity_from_to_date {
    my ( $self, $from, $to ) = @_;

    $to //= DateTime->now;

    if ( ref $to eq 'DateTime' ) {
        $to = $self->format_datetime( $to );
    }
    if ( ref $from eq 'DateTime' ) {
        $from = $self->format_datetime( $from );
    }

    $self->search_rs({
        'activity.created' => {
            -between => [ $from, $to ],
        },
    })->prefetch( { subscriptions => 'activity' } )
      ->having( \[ 'count(activity.*) > 0' ] )
      ->group_by( 'users' );
}

sub find_by_username {
    my ( $self, $username ) = @_;
    $self->search( \[ 'LOWER(username) = ?', ( lc( $username ) ) ], )
         ->first;
}

1;
