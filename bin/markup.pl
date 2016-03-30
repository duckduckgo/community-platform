#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";
my $root = $FindBin::Dir . "/../";

use autodie;
use File::Copy;
use File::Spec::Functions;
use File::Path qw/ make_path /;
use JSON::MaybeXS;

my $build_dir = catdir( $ENV{HOME}, 'ddgc/ddh-userpages' );

sub json {
    local $/;
    open my $fh, '<:encoding(UTF-8)', catfile( $build_dir, 'users.json' );
    return <$fh>;
}

my $users = JSON::MaybeXS->new( utf8 => 1 )->decode( json );
for my $user ( @{ $users } ) {
    my $user_dir = catdir( $build_dir, $user );
    make_path( $user_dir );
    copy( catfile( $root, 'root/static/pages/ddh_up_index.html' ),
          catfile( $user_dir, 'index.html' ) );
}

