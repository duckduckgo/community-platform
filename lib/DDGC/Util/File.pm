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

my $ROOT_PATH = DDGC::Config->new->appdir_path;

sub ia_page_version {

    if( -f "$ROOT_PATH/root/static/js/ia.js"){
        return '';
    }

    my $file = $ROOT_PATH."package.json";

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
