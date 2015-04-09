#!/usr/bin/env perl

use strict;
use warnings;

use Time::Piece;
use Time::Seconds;
use DateTime;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use DDGC;

die 'This emails people... See crontab.' if (!$ARGV[0] || $ARGV[0] ne '--yes-really-send-email');

my $ddgc  = DDGC->new;
my $today = localtime;
my $reachout_start = '2015-04-10';

my $mail_dates = [
    {
        start => ($today - ONE_DAY)->ymd,
        end   => ($today)->ymd,
        mail  => 'campaigninfo1',
        subject => 'Helping friends & family take back their privacy',
    },
    {
        start => ($today - (ONE_DAY * 14))->ymd,
        end   => ($today - (ONE_DAY * 13))->ymd,
        mail  => 'campaigninfo2',
        subject => 'Tips to help your friends & family try out DuckDuckGo',
    },
    {
        start => ($today - (ONE_DAY * 27))->ymd,
        end   => ($today - (ONE_DAY * 26))->ymd,
        mail  => 'campaigninfo3',
        subject => '3 days to go before you can get your DuckDuckGo t-shirt!',
    },
];

for my $mail_date (@{$mail_dates}) {
    next if $mail_date->{start} lt $reachout_start;
    my $responses = $ddgc->rs('User::CampaignNotice')->search(
        {
            responded => {
                '>=' => $mail_date->{start},
                '<'  => $mail_date->{end},
            },
            campaign_id => 1,
        }
    );
    next if !$responses;

    while (my $response = $responses->next) {
        my $address = $response->get_verified_campaign_email;
        next if !$address;
        my $stash = { return_date => ($response->responded + DateTime::Duration->new( days => 30 ))->strftime("%b %e"), };
        my $body = $ddgc->xslate->render('email/' . $mail_date->{mail} . '.tx', $stash);
        $ddgc->postman->html_mail(
            1,
            $address,
            '"DuckDuckGo Share It + Wear It" <sharewear@duckduckgo.com>',
            '[DuckDuckGo Share It + Wear It] ' . $mail_date->{subject},
            $body,
        );
    }
}

