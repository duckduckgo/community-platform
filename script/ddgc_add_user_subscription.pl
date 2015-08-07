#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;

use FindBin;
use lib $FindBin::Dir . "/../lib";
use DDGC::Base::Web::Common;

my $subscription;
my $ddgc_config = config->{ddgc_config};

sub usage {
    printf "%s --user (username) --subscription (subscription name) [--meta{1..3} extra]\n\n", $0;
    printf "See DDGC::Config::Subscriptions for subscription types\n";
}

GetOptions(
    "user|u=s"         => \$subscription->{user},
    "subscription|s=s" => \$subscription->{sub},
    "meta1=s"          => \$subscription->{meta1},
    "meta2=s"          => \$subscription->{meta2},
    "meta3=s"          => \$subscription->{meta3},
);

usage if (!$subscription->{sub} || !$subscription->{user});

my $sub = $subscription->{sub};

die sprintf( "Unknown subscription type %s", $subscription->{sub} )
    if ( !config->{ddgc_config}->subscriptions->can( $subscription->{sub} ) );

my $user = rset('User')->search(
    \[ 'LOWER(username) = ?', ( lc($subscription->{user}) ) ],
)->first;

die sprintf( "User %s not found", $subscription->{user} ) if !$user;

$user->find_or_create_related( 'subscriptions',
     config->{ddgc_config}->subscriptions->$sub(
         ( $subscription->{meta1} )
            ? ( meta1 => $subscription->{meta1} )
            : (),
         ( $subscription->{meta2} )
            ? ( meta2 => $subscription->{meta2} )
            : (),
         ( $subscription->{meta3} )
            ? ( meta3 => $subscription->{meta3} )
            : (),
     )
);

