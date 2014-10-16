#!/usr/bin/env perl

use FindBin;
use lib $FindBin::Dir . "/../lib";

use strict;
use warnings;
use feature "say";
use Data::Dumper;
use Try::Tiny;
use File::Copy qw( move copy );

my $upload_meta = DDGC::Config->new->rootdir_path."cache/all_meta.json";

die unless (-f $upload_meta);

use DDGC;
use JSON;
use IO::All;
use Term::ANSIColor;

# plenty of time for scp incase it's running
sleep(2);

my $d = DDGC->new;
my $meta = '';

# if there are problems reading the meta data file
# then log the error, rename the file do we don't
# try reading it again, and die
try {
    $meta = decode_json(io->file($upload_meta)->slurp);
}
catch {
    $d->errorlog("Error reading metadata: $_");
    move $upload_meta, $upload_meta.".error";
    die;
};

sub debug { 1 };

say "there are " . (scalar @{$meta}) . " IAs" if debug;

# say JSON->new->utf8(1)->pretty(1)->encode($meta);

my $line = 1;

for my $ia (@{$meta}) {

    if (debug) {
        print color 'red';
        print "$ia->{name}\n";
        print color 'reset';
    }


    if ($ia->{topic}) {
        $ia->{topic} = JSON->new->utf8(1)->encode($ia->{topic});
    }

    if ($ia->{code}) {
        $ia->{code} = JSON->new->utf8(1)->encode($ia->{code});
    }

    if ($ia->{other_queries}) {
        $ia->{other_queries} = JSON->new->utf8(1)->encode($ia->{other_queries});
    }

    if ($ia->{attribution_orig}) {
        $ia->{attribution_orig} = JSON->new->utf8(1)->encode($ia->{attribution_orig});
    }

    if ($ia->{attribution}) {
        $ia->{attribution} = JSON->new->utf8(1)->encode($ia->{attribution});
    }

    if ($ia->{screenshots}) {
        $ia->{screenshots} = JSON->new->utf8(1)->encode($ia->{screenshots});
    }

    try {
        $d->rs('InstantAnswer')->update_or_create($ia);
    }
    catch {
        $d->errorlog("Error updating database: $_");
        copy $upload_meta, $upload_meta.".error";
    };


    # debug key val
    # for my $k (keys %{$ia}) {
    #     my $val = $ia->{$k} || "(null)";
    #     print "   $k: ";
    #     print color 'green';
    #     print "$val\n";
    #     print color 'reset';
    # }
    # exit 1 if (++$line > 5);


}

unlink($upload_meta);

