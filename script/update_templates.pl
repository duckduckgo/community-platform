#!/usr/bin/env perl
# check IA pages for templates
use strict;
use warnings;
use FindBin;
use lib $FindBin::Dir . "/../lib";
use JSON;
use Data::Dumper;
use DDG::Meta::Data;
use IO::All;

my $meta = DDG::Meta::Data->by_id;

Main: {
    # find stuff that doesn't have a template
    while( my( $id, $data) = each $meta){
        # spice only?? goodies might have templates?
        next if $data->{repo} ne 'spice';


    }
}
