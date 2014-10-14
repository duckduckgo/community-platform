package DDGC::Util::File;
# ABSTRACT: Utility functions for files

use strict;
use warnings;
use Exporter 'import';
use JSON;
use IO::All;

our @EXPORT = qw(
	ia_page_version
);

my $INST = '';
sub ia_page_version {

    if( -f "$INST/ia.js"){
        return '';
    }

    my $file = DDGC::Config->new->appdir_path."package.json";

    my $pkg < io($file);

    my $json = decode_json($pkg);

    if($json->{'version'} =~ /(\d+)\.(\d+)\.(\d+)/){
        my $version = $2 - 1;
        return qq($1.$version.$3);
    } else {
        return '';
    }
}

1;
