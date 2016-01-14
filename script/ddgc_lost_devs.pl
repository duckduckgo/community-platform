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
use Spreadsheet::WriteExcel;

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

my $book = Spreadsheet::WriteExcel->new('dev-without-pr.xls');
my $sheet = $book->add_worksheet();
my $row = 0;

foreach my $result (@results){
    next if $result->{dev_milestone} !~ /planning/i;
    next unless $d->rs('InstantAnswer::Issues')->search({is_pr => 1, instant_answer_id => $result->{id}});
    next unless $result->{developer};

    my $dev = from_json $result->{developer} if exists $result->{developer};
    next unless $dev->[0]->{name};

    my $today = localtime;
    my $link =  qq(https://duck.co/ia/view/$result->{id});

    my @data = [
        $dev->[0]->{name},
        $link,
        $result->{created_date},
        $today
    ];

    for(my $i = 0; $i < scalar @data; $i++){
        $sheet->write($row, $i, $data[$i]); 
    }
    $row++
}
