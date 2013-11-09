#!/usr/bin/env perl

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use DDGC;

my $uploader_username = shift @ARGV;
my $dist_filename = shift @ARGV;

my $ddgc = DDGC->new;
my $uploader = $ddgc->find_user($uploader_username);

die "uploader not found" unless $uploader;
die "uploader is not admin" unless $uploader->admin;

$ddgc->duckpan->add_user_distribution($uploader,$dist_filename);

exit 0;