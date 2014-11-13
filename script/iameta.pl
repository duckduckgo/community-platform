#!/usr/bin/env perl

use FindBin;
use lib $FindBin::Dir . "/../lib";

use strict;
use warnings;
use feature "say";
use Data::Dumper;
use Try::Tiny;
use File::Copy qw( move );

my $upload_meta = DDGC::Config->new->rootdir_path."cache/all_meta.json";

exit 0 unless (-f $upload_meta);

use DDGC;
use JSON;
use IO::All;
use Term::ANSIColor;

# plenty of time for scp incase it's running
sleep(2);

my $d = DDGC->new;
my $meta = '';


# TODO commented out for testing

# if(-f $upload_meta.".copy"){
#     unlink $upload_meta.".copy";
# }

# move $upload_meta, $upload_meta.".copy";

# if there are problems reading the meta data file
# then log the error, rename the file do we don't
# try reading it again, and die
try {
    $meta = decode_json(io->file($upload_meta)->slurp);
}
catch {
    $d->errorlog("Error reading metadata: $_");
    die;
};

sub debug { 1 };

say "there are " . (scalar @{$meta}) . " IAs" if debug;

my $line = 1;

for my $ia (@{$meta}) {

    if (debug) {
        print color 'red';
        print "$ia->{name}\n";
        print color 'reset';
    }

    if ($ia->{code}) {
        $ia->{code} = JSON->new->ascii(1)->encode($ia->{code});
    }

    if ($ia->{other_queries}) {
        $ia->{other_queries} = JSON->new->ascii(1)->encode($ia->{other_queries});
    }

    if ($ia->{attribution_orig}) {
        $ia->{attribution_orig} = JSON->new->ascii(1)->encode($ia->{attribution_orig});
    }

    if ($ia->{attribution}) {
        $ia->{attribution} = JSON->new->ascii(1)->encode($ia->{attribution});
    }

    if ($ia->{screenshots}) {
        $ia->{screenshots} = JSON->new->ascii(1)->encode($ia->{screenshots});
    }

    if ($ia->{src_options}) {
        $ia->{src_options} = JSON->new->ascii(1)->encode($ia->{src_options});
    }

    try {
        $d->rs('InstantAnswer')->update_or_create($ia);
    }
    catch {
        $d->errorlog("Error updating database: $_");
    };

    # get the IA references
    my $new_ia = $d->rs('InstantAnswer')->find($ia->{id});

    if ($new_ia) {

        # did we have topics?
        if ($ia->{topic}) {

            for (@{$ia->{topic}}) {

                if (debug) {
                    print color 'green';
                    print "\t$_\n";
                    print color 'reset';
                }


                # create topic if it doesn't exist. Very simple, doesn't matter for now
                my $topic = $d->rs('Topic')->update_or_create({name => $_});

                # reference it from IA
                $new_ia->add_to_topics($topic);
            }
        }
    }


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

