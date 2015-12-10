#!/usr/bin/env perl
use FindBin;
use lib $FindBin::Dir . "/../lib";
use strict;
use Data::Dumper;
use DDGC;
use IO::All;
use File::Find::Rule;
use Try::Tiny;
use Cwd 'getcwd';

my $d = DDGC->new;

# get IA traffic stats
system( q(sudo /usr/bin/s3cmd -c /usr/local/etc/s3cmd/ddgc-stats.s3cfg ls s3://ddg-statistics/ | sort -k1 -r | head -n1 | awk {'print $4'} | xargs /usr/bin/s3cmd -c /usr/local/etc/s3cmd/ddgc-stats.s3cfg -f get && gzip -df statistics_*.gz) );

my $update = sub { 
    $d->rs('InstantAnswer::Traffic')->delete;

    my ($file) = File::Find::Rule
        ->file
        ->name("statistics*.sql")
        ->in( getcwd($0) );

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

    unlink 'traffic.sql';
    unlink $file;
};

try{
    $d->db->txn_do( $update );
} catch {
    print "Update error, rolling back\n";
    warn $_;
    $d->errorlog("Error updating iameta, Rolling back update: $_");
};

