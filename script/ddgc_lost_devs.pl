#!/usr/bin/env perl
# Find IA pages created since a given date that don't have an linked PR
# Look up the devs github data 
# usage: ./ddgc_lost_devs.pl --since=yyyy-mm-dd
#
use strict;
use warnings;
use FindBin;
use lib $FindBin::Dir . "/../lib";
use JSON;
use DDGC;
use Data::Dumper;
use Net::GitHub::V3;
use Getopt::Long;
use HTTP::Date;

my $since;
GetOptions(
    'since=s' => \$since
);
die ('usage: ./ddgc_lost_devs.pl --since=yyyy-mm-dd') if !$since;

$since = localtime( str2time($since));

my $d = DDGC->new;

my $rs = $d->rs('InstantAnswer');
my @results = $rs->search(
    { created_date => { '>' => $since }},
    { join => 'issues',
        result_class => 'DBIx::Class::ResultClass::HashRefInflator'
    }
)->all;

foreach my $result (@results){
    next if $result->{dev_milestone} !~ /planning/i;
    next unless $d->rs('InstantAnswer::Issues')->search({is_pr => 1, instant_answer_id => $result->{id}});

    my $dev = from_json $result->{developer} if exists $result->{developer};

    printf("IA: %s\t Date: %s\tDev: %s\n",
        $result->{id},
        $result->{created_date},
        $dev->[0]->{url}
    );
}
