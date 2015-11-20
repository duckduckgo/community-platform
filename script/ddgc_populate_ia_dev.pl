#!/usr/bin/env perl

use strict;
use warnings;

$ENV{DDGC_IA_AUTOUPDATES} = 0;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use JSON::MaybeXS;
use HTTP::Tiny;
use DDGC;
use Carp;

my $d = DDGC->new;
my $h = HTTP::Tiny->new;
my $r = $h->get('https://duck.co/ia/repo/all/json?all_milestones=1');

croak sprintf("GET failed, %s: %s", $r->{status}, $r->{reason}) if !$r->{success};

my $data = decode_json( $r->{content} );

for my $ia_id (keys $data) {
    my $topics = delete $data->{$ia_id}->{topic};
    my $developer = delete $data->{$ia_id}->{developer};
    my $attribution = delete $data->{$ia_id}->{attribution};
    my $src_options = delete $data->{$ia_id}->{src_options};

    my $ia = $d->rs('InstantAnswer')->update_or_create({
        meta_id => $ia_id,
        %{ $data->{$ia_id} },
        ( $attribution )
            ? ( attribution => encode_json( $attribution ) )
            : (),
        ( $src_options )
            ? ( src_options => encode_json( $src_options ) )
            : (),
        ( $developer )
            ? ( developer => encode_json( $developer ) )
            : (),
    });

    for my $topic ( @{ $topics } ) {
        my $topic_id = $d->rs('Topic')->find_or_create({
            name => $topic,
        })->get_column('id');
        $ia->update_or_create_related(
            instant_answer_topics => { topics_id => $topic_id }
        );
    }
}

