#!/usr/bin/env perl

use strict;
use warnings;

use Time::Piece;
use Time::Seconds;
use DateTime;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use DDGC;

die 'This emails people... See crontab' if $ARGV[1] ne '--yes-really-send-email';

my $ddgc  = DDGC->new;
my $today = localtime;
my $reachout_start = '2015-04-07';

my $mail_dates = [
    {
        start => ($today - ONE_DAY)->ymd,
        end   => ($today)->ymd,
        mail  => 'campaigninfo1',
    },
    {
        start => ($today - (ONE_DAY * 14))->ymd,
        end   => ($today - (ONE_DAY * 13))->ymd,
        mail  => 'campaigninfo2',
    },
    {
        start => ($today - (ONE_DAY * 28))->ymd,
        end   => ($today - (ONE_DAY * 27))->ymd,
        mail  => 'campaigninfo3',
    },
];

for my $mail_date (@{$mail_dates}) {
    return if $mail_date->{start} lt $reachout_start;
    my $responses = $ddgc->rs('User::CampaignNotice')->search(
        {
            responded => {
                '>=' => $mail_date->{start},
                '<'  => $mail_date->{end},
            }
        }
    );
    next if !$responses;

    while (my $response = $responses->next) {
        my $address = $response->get_verified_campaign_email;
        next if !$address;
        $ddgc->postman->template_mail(
            1,
            $address,
            '"DuckDuckGo Share It + Wear It" <sharewear@duckduckgo.com>',
            '[DuckDuckGo Share It + Wear It] ' . $mail_date->{subject},
            $mail_date->{mail},
            {
                return_date => ($response->responded + DateTime::Duration->new( days => 30 ))->strftime("%b %e"),
            },
        );
    }
}

