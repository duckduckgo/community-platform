#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Long;
use Try::Tiny;

use FindBin;
use lib $FindBin::Dir . "/../lib";
use DDGC::Util::Script::AddUserSubscription;

sub usage {
    printf "%s --user (username) --subscription (subscription name) [--meta{1..3} extra]\n\n", $0;
    printf "See DDGC::Config::Subscriptions for subscription types\n";
}

my $sub;
GetOptions(
    "user|u=s"         => \$sub->{user},
    "subscription|s=s" => \$sub->{sub},
    "meta1=s"          => \$sub->{meta1},
    "meta2=s"          => \$sub->{meta2},
    "meta3=s"          => \$sub->{meta3},
);

try {
    DDGC::Util::Script::AddUserSubscription->new( sub => $sub )->execute;
} catch {
    printf "%s\n", $_;
    usage;
    exit 1;
};

