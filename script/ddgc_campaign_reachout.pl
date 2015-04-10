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
my $lastrun_file = $ddgc->config->rootdir_path . '/ddgc_campaign_reachout_last_run';
my $lastrun_date;

if (-f $lastrun_file) {
    open my $fh, '<', $lastrun_file;
    chomp( $lastrun_date = <$fh> );
}

my $today = localtime;
die "Campaign reach-out already run today!" if ($lastrun_date && $today->ymd eq $lastrun_date);

my $reachout_start = '2015-04-09';

my $mail_dates = [
    {
        start => ($today - ONE_DAY)->ymd,
        end   => ($today)->ymd,
        mail  => '1',
        subject => 'Helping friends & family take back their privacy',
    },
    {
        start => ($today - (ONE_DAY * 14))->ymd,
        end   => ($today - (ONE_DAY * 13))->ymd,
        mail  => '2',
        subject => 'Tips to help your friends & family try out DuckDuckGo',
    },
    {
        start => ($today - (ONE_DAY * 27))->ymd,
        end   => ($today - (ONE_DAY * 26))->ymd,
        mail  => '3',
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
            unsubbed    => 0,
        }
    );
    next if !$responses;

    while (my $response = $responses->next) {
        my $address = $response->get_verified_campaign_email;
        next if !$address;
        my $unsub_hash = $response->unsub_hash;
        die ("Could not compute unsubscribe hash for " . $response->user->username) if !$unsub_hash;
        my $stash = {
            return_date => ($response->responded + DateTime::Duration->new( days => 30 ))->strftime("%b %e"),
            unsub_link  => $ddgc->config->web_base . '/' .
                           join('/', (qw/my unsubscribe/, lc($response->user->username), $unsub_hash)) .
                           '?from=' . $mail_date->{mail},
        };
        my $body = $ddgc->xslate->render('email/campaigninfo' . $mail_date->{mail} . '.tx', $stash);
        $ddgc->postman->html_mail(
            1,
            $address,
            '"DuckDuckGo Share it & Wear it" <sharewear@duckduckgo.com>',
            '[DuckDuckGo Share it & Wear it] ' . $mail_date->{subject},
            $body,
        );
    }
}

open my $fh, '>', $lastrun_file;
print $fh $today->ymd;
