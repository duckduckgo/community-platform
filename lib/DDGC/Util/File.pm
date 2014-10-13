package DDGC::Util::File;
# ABSTRACT: Utility functions for files

use strict;
use warnings;
use Exporter 'import';
use JSON;
use IO::All;
use Data::Dumper;

my $ROOT_DIR = '/home/ubuntu/community-platform';

our @EXPORT = qw(
	ia_page_version
);


sub ia_page_version {
    my $pkg < io("$ROOT_DIR/package.json");

    my $json = decode_json($pkg);

    if($json->{'version'} =~ /(\d+)\.(\d+)\.(\d+)/){
        my $version = $2 - 1;
        return qq($1.$version.$3);
    }
}


