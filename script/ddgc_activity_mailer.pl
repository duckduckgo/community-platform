#!/usr/bin/env perl

use strict;
use warnings;

use DateTime;

use FindBin;
use lib $FindBin::Dir . "/../lib";
use DDGC::Base::Web::Common;
use DDGC::Util::Email;

my $ddgc_config = config->{ddgc_config};

my $dt = DateTime->now;
my $dt_rounded = DateTime->new(
    year  => $dt->year,
    month => $dt->month,
    day   => $dt->day,
    hour  => $dt->hour,
);

my $email = DDGC::Util::Email->new(
    smtp_config => {
        host          => $ddgc_config->smtp_host,
        ssl           => $ddgc_config->smtp_ssl,
        sasl_username => $ddgc_config->smtp_username,
        sasl_password => $ddgc_config->smtp_password,
    }
);

my $users = rset('User')->unsent_activity_from_date(
    $dt_rounded->subtract( hours => 1 );
);


for my $user ( $users->all ) {
    next if ( !$user->email || !$user->email_verified );

    my $activity_count = $user->subscriptions->activity->count;
    my $subject = sprintf '[DuckDuckGo Community] %s new update%s!',
        $activity_count, ($activity_count == 1) ? '' : 's';

    $email->send( {
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

