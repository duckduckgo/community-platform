use strict;
use warnings;
package DDGC::Util::Script::ActivityMailer;

use DateTime;
use List::Util qw/ sum /;
use Moo;

with 'DDGC::Util::Script::Base::Service';
with 'DDGC::Util::Script::Base::ServiceEmail';

has now => (
    is => 'ro',
    lazy => 1,
    builder => '_build_now'
);
sub _build_now {
    DateTime->now( time_zone => 'US/Eastern' );
}

has now_rounded => (
    is => 'ro',
    lazy => 1,
    builder => '_build_now_rounded'
);
sub _build_now_rounded {
    my ( $self ) = @_;
    DateTime->new(
        year  => $self->now->year,
        month => $self->now->month,
        day   => $self->now->day,
        hour  => $self->now->hour,
    );
}

has one_hour_ago_rounded => (
    is => 'ro',
    lazy => 1,
    builder => '_build_one_hour_ago_rounded'
);
sub _build_one_hour_ago_rounded {
    my ( $self ) = @_;
    DateTime->from_object(
        object => $self->now_rounded
    )->subtract( hours => 1 );
}

has users => (
    is => 'ro',
    lazy => 1,
    builder => '_build_users'
);
sub _build_users {
    my ( $self ) = @_;
    rset('User')->unsent_activity_from_to_date(
        $self->one_hour_ago_rounded,
        $self->now_rounded,
    );
}

sub email {
    my ( $self, $user ) = @_;
    my $activity_count = sum map
        { $_->activity->count }
        $user->subscriptions->all;
    my $subject = sprintf '[DuckDuckGo Community] %s new update%s!',
        $activity_count, ($activity_count == 1) ? '' : 's';

    $self->smtp->send( {
        to       => $user->email,
        verified => $user->email_verified,
        from     => 'ddgc@duckduckgo.com',
        subject  => $subject,
        template => 'email/activity.tx',
        content  => {
            user => $user,
        }
    } );
}

sub execute {
    my ( $self ) = @_;

    $self->email( $_ ) for ( $self->users->all );

    return $self->smtp->transport;
}

1;
