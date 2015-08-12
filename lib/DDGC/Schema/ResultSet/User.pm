package DDGC::Schema::ResultSet::User;

# ABSTRACT: Resultset class for users

use Moo;
extends 'DDGC::Schema::ResultSet';

sub unsent_activity_from_date {
    my ( $self, $datetime ) = @_;

    if ( ref $datetime eq 'DateTime' ) {
        $datetime = $self->format_datetime( $datetime );
    }

    $self->search_rs({
        'activity.created' => { '>=' => $datetime },
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
