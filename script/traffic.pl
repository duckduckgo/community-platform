#!/usr/bin/env perl
use FindBin;
use lib $FindBin::Dir . "/../lib";
use strict;
use warnings;
use Data::Dumper;
use DDGC;
use IO::All;
use File::Find::Rule;
use Try::Tiny;

my $d = DDGC->new;

# get IA traffic stats
system( qq(sudo /usr/bin/s3cmd -c /root/.s3cfg get s3://ddg-statistics/* && gzip -df statistics_*.gz) );

my $update = sub { 
    $d->rs('InstantAnswer::Traffic')->delete;

    my ($file) = File::Find::Rule
        ->file
        ->name("*.sql")
        ->in('/home/ddgc/community-platform/script');

    # process data from s3 and add to traffic db
    my @lines = io($file)->slurp;

    warn scalar @lines;

    my $capture;
    my $traffic;
    foreach my $line (@lines){
        if($line =~ /copy pixel_log.+/i){
            $capture = 1;
        }

        if($capture){
            $traffic .= $line;
        }

        if($capture && $line =~ /\\\./){
            last;
        }
    }

    $traffic =~ s/pixel_log/instant_answer_traffic/;

    $traffic > io('traffic.sql');

    system(qq(psql -U ddgc -f traffic.sql) );

};

try{
    $d->db->txn_do( $update );
} catch {
    print "Update error, rolling back\n";
    $d->errorlog("Error updating iameta, Rolling back update: $_");
};

