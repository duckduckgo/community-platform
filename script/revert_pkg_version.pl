#!/usr/bin/env perl
# used by grunt to revert the package version
use strict;
use warnings;
use Path::Tiny;

my $dir = path("../");
my $grunt_package_file = path('package.json');

my @file_lines = $grunt_package_file->lines;

for(my $i = 0; $i < scalar @file_lines; $i++){
    if($file_lines[$i] =~ m/version": "(\d+).(\d+).(\d)/){
        my $version  = $2;
        $version--;
        $file_lines[$i] = qq(  "version": "$1.$version.$3",). "\n";
    }
}

$grunt_package_file->spew(@file_lines);
