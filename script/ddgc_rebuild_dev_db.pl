#!/usr/bin/env perl
# recover a dev database with whatever is live on duck.co/ia/view/$repo/json enpoints
#
#
use FindBin;
use lib $FindBin::Dir . "/../lib";
use strict;
use warnings;
use feature "say";
use Data::Dumper;
use Try::Tiny;
use File::Copy qw( move );
use LWP::Simple;

sub debug { 0 };

use DDGC;
use JSON;
use IO::All;
use Term::ANSIColor;
use Term::ProgressBar;

my $d = DDGC->new;

my $update = sub { 
    
    print "Deleting all tables before updating\n";
    $d->rs('InstantAnswer')->delete;
    $d->rs('Topic')->delete;

    # get data from complat json endpoints
    my @data;
    foreach my $repo (qw(spice goodies fathead longtail)){
        my $res = get "http://duck.co/ia/repo/$repo/json" or warn  "Didn't get repo: $repo, try again";
        push(@data, from_json($res));
    }
    # combine the hashes
    my $meta = { map{ %$_ }(@data)};
    my $line = 1;
    my $total = keys %$meta;

    say "there are " . $total . " IAs" if debug;

    print "Downloading IA metadata\n";
    my $progress_bar = Term::ProgressBar->new($total);
    # get the full metadata from /ia/view/$ia/json
    while( my($key, $data) = each $meta ){
        $progress_bar->update($line);
        my $more_data = get "http://duck.co/ia/view/$key/json" or warn "Didn't get more data for IA: $key";
        $more_data = from_json($more_data);
        $meta->{$key} = $more_data->{live};
        $line++;
        # so we don't kill the complat
        sleep(1);
    }

    print "Updating database\n";

    while( my($key, $ia) = each $meta) {
        
        if (debug) {
            print color 'red';
            print "$ia->{name}\n";
            print color 'reset';
        }

        $ia->{meta_id} = $ia->{id};

        # get these with ghIssues.pl
        delete $ia->{issues};

        # get column attributes
        my $rs = $d->rs('InstantAnswer')->get_column('id');
        
        # get column data and convert if is_json
        while(my($column) = each $ia){
            my $column_data = $rs->{_parent_resultset}->{result_source}->{_columns}->{$column};
            if($column_data->{is_json} && $ia->{$column}){
                $ia->{$column} = JSON->new->ascii(1)->encode($ia->{$column});
            }
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

