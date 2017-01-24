package DDGC::Schema::ResultSet::Subscriber;

use Moo;
extends 'DDGC::Schema::ResultSet';

use DateTime;
use DateTime::Duration;

sub campaign {
    my ( $self, $c ) = @_;
    $self->search_rs( { campaign => $c } );
}

sub subscribed {
    my ( $self ) = @_;
    $self->search_rs( { unsubscribed => 0 } );
}

sub verified {
    my ( $self ) = @_;
    $self->search_rs( { verified => 1 } );
}

sub unverified {
    my ( $self, $single_opt_in ) = @_;
    return $self if $single_opt_in;
    $self->search_rs( { verified => 0 } );
}

sub unbounced {
    my ( $self ) = @_;
    $self->search_rs( { bounced => 0, complaint => 0 } );
}

sub mail_unsent {
    my ( $self, $campaign, $email ) = @_;
    $self->search_rs( {
        email_address => { -not_in => \[
                'SELECT email_address
                 FROM subscriber_maillog
                 WHERE campaign = ?
                 AND email_id = ?',
                ( $campaign, $email )
            ],
        }
    } );
}

sub verification_mail_unsent_for {
    my ( $self, $campaign ) = @_;
    $self->search_rs( {
        email_address => { -not_in => \[
                'SELECT email_address
                 FROM subscriber_maillog
                 WHERE campaign = ?
                 AND email_id = \'v\'',
                $campaign
            ],
        }
    } );
}

sub by_days_ago {
    my ( $self, $days ) = @_;
    my $today = DateTime->now->truncate( to => 'day' );
    my $end = $self->format_datetime(
        $today->subtract( days => ( $days - 1 ) )
    );
    my $start = $self->format_datetime(
        $today->subtract( days => 1 )
    );

    $self->search_rs( {
        created => { -between => [ $start, $end ] }
    } );
}

sub handle_bounces {
    my ( $self, $message ) = @_;
    my $update_params;
    my @emails;
    if ( $message->{notificationType} eq 'Bounce' && $message->{bounce}->{bounceType} eq 'Permanent' ) {
        $update_params = { bounced => 1 };
        push @emails, map { $_->{emailAddress} } @{$message->{bounce}->{bouncedRecipients}};
    }
    elsif ( $message->{notificationType} eq 'Complaint' ){
        $update_params = { complaint => 1 };
        push @emails, map { $_->{emailAddress} } @{$message->{complaint}->{complainedRecipients}};
    }
    return { ok => 1 } if !$update_params || !@emails;
    for my $email (@emails) {
        my $subscribers = $self->search(\[ 'LOWER( email_address ) = ?', lc( $email ) ]);
        $subscribers->update( $update_params ) if $subscribers;
    }
    return { ok => 1 };
}

1;
