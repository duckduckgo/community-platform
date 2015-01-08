#!/usr/bin/env perl

use FindBin;
use lib $FindBin::Dir . "/../lib";

use strict;
use warnings;
use feature "say";
use Data::Dumper;
use Try::Tiny;
use File::Copy qw( move );

sub debug { 0 };

my $upload_meta = DDGC::Config->new->rootdir_path . "cache/all_meta.json";
my $meta_copy = $upload_meta . '.copy';

exit 0 unless (-f $upload_meta);

use DDGC;
use JSON;
use IO::All;
use Term::ANSIColor;

# plenty of time for scp incase it's running
sleep(2);

my $d = DDGC->new;
my $meta = '';
my $nuke_tables = 0;
$nuke_tables = 1 if $ARGV[0] && $ARGV[0] eq "delete";

if($nuke_tables){
    print "Deleting all tables before updating\n";
    $d->rs('InstantAnswer')->delete;
}

if(-f $meta_copy){
    unlink $meta_copy;
}

move $upload_meta, $meta_copy;

# if there are problems reading the meta data file
# then log the error, rename the file do we don't
# try reading it again, and die
try {
    $meta = decode_json(io->file($meta_copy)->slurp);
}
catch {
    $d->errorlog("Error reading metadata");
    die;
};

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

            for my $topic_name (@{$ia->{topic}}) {

                if (debug) {
                    print color 'green';
                    print "\t$topic_name\n";
                    print color 'reset';
                }

                # create topic if it doesn't exist.

                my $topic = $d->rs('Topic')->update_or_create({name => $topic_name});

                # add it to the IA
                unless ($d->rs('InstantAnswer::Topics')->find({instant_answer_id => $ia->{id}, topics_id => $topic->id})) {
                    print "adding topic $topic_name to $ia->{id}\n" if debug;
                    $new_ia->add_to_topics($topic);
                }

            }

            # $ia->{topic} = JSON->new->ascii(1)->encode($ia->{topic});
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

