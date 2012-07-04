#!/usr/bin/env perl

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use DDGC;

my $dist_filename = shift @ARGV;

my $ddgc = DDGC->new;
my $cpanuser = $ddgc->db->resultset('User')->find({ username => 'cpan' });

die "cpan user not found" unless $cpanuser;
die "cpan user not admin" unless $cpanuser->admin;

$ddgc->duckpan->add_user_distribution($cpanuser,$dist_filename);
