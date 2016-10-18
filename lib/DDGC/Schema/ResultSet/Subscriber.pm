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
    my ( $self ) = @_;
    $self->search_rs( { verified => 0 } );
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
        $today->subtract( days => $days )
    );
    my $start = $self->format_datetime(
        $today->subtract( days => 1 )
    );

    $self->search_rs( {
        created => 
    } );
}

1;
