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
            ( $to )
            ? ( -between => [ $from, $to ] )
            : ( '>=' => $from ),
        },
    })->prefetch( { subscriptions => 'activity' } )
      ->having( \[ 'count(activity.id) > 0' ] )
      ->group_by( 'users' );
}

sub find_by_username {
    my ( $self, $username ) = @_;
    $self->search( \[ 'LOWER(username) = ?', ( lc( $username ) ) ], )
         ->one_row;
}

sub handle_bounces {
    my ( $self, $message ) = @_;
    if ( ( $message->{bounce}->{bounceType}
            && $message->{bounce}->{bounceType} eq 'Permanent' )
            || $message->{notificationType} eq 'Complaint' ) {
        my @emails;
        push @emails,
             map { $_->{emailAddress} }
             @{$message->{bounce}->{bouncedRecipients}}
             if $message->{bounce}->{bouncedRecipients};
        push @emails,
             map { $_->{emailAddress} }
             @{$message->{complaint}->{complainedRecipients}}
             if $message->{complaint}->{complainedRecipients};
        for my $email ( @emails ) {
            my $users = $self->search(\[ 'LOWER( email ) = ?', lc( $email ) ]);
            $users->update({ email_verified => 0 }) if $users;
        }
    }
    return { ok => 1 };
}

1;
