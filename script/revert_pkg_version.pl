#!/usr/bin/env perl
# used by grunt to revert the package version
# and remove version files
use strict;
use warnings;
use Path::Tiny;

my $dir = path("../");
my $grunt_package_file = path('package.json');
my $version;

my @file_lines = $grunt_package_file->lines;

my $revert_release = $ARGV[0];

if($revert_release){
    for(my $i = 0; $i < scalar @file_lines; $i++){
        if($file_lines[$i] =~ m/version": "(\d+).(\d+).(\d)/){
            $version  = $2;
            $version--;
            $file_lines[$i] = qq(  "version": "$1.$version.$3",). "\n";
        }
    }

    $grunt_package_file->spew(@file_lines);

    path("root/static/css/ia0.$version.0.css")->remove;
    path("root/static/css/ddgc0.$version.0.css")->remove;
    path("root/static/js/ia0.$version.0.js")->remove;
    path("root/static/js/ddgc0.$version.0.js")->remove;

    print qq(Reverting to version: 0.$version.0);
}


path("root/static/css/ia.css")->remove;
path("root/static/css/ddgc.css")->remove;
path("root/static/js/ia.js")->remove;
path("root/static/js/ddgc.js")->remove;
path("src/templates/handlebars_tmp")->remove;
