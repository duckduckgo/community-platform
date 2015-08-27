#!/usr/bin/env perl
use FindBin;
use lib $FindBin::Dir . "/../lib";
use strict;
use warnings;
use feature "say";
use Data::Dumper;
use Try::Tiny;
use File::Copy qw( move );

BEGIN {
    $ENV{DDGC_IA_AUTOUPDATES} = 1;
}

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

if(-f $meta_copy){
    unlink $meta_copy;
}
move $upload_meta, $meta_copy;

# try reading metadata file
try {
    my $json = io->file($meta_copy)->slurp;
    $meta = from_json($json);
}
catch {
    $d->errorlog("Error reading metadata: $_");
    die;
};

my $update = sub { 
    if($nuke_tables){
        print "Deleting all tables before updating\n";
        $d->rs('InstantAnswer')->delete;
        $d->rs('Topic')->delete;
    }

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

        $d->rs('InstantAnswer')->update_or_create($ia);

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

};

try{
    $d->db->txn_do( $update );
} catch {
    print "Update error, rolling back\n";
    $d->errorlog("Error updating iameta, Rolling back update: $_");
};

