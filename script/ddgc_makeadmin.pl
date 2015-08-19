#!/usr/bin/env perl

use utf8;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use DDGC;

my $username = shift @ARGV;

die "please give a username" unless $username;

my $ddgc = DDGC->new;
my $schema = $ddgc->db;

my $user = $schema->resultset('User')->find({ username => $username });

die "user not found" unless $user;

$user->add_role('admin');
$user->update;

print "User ".$username." is now admin...\n";
