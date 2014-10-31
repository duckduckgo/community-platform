#!/usr/bin/env perl

use utf8;

use FindBin;
use lib $FindBin::Dir . "/../lib";

use strict;
use DDGC;

my $username = shift @ARGV;
my $ia_name =  shift @ARGV;

die "please give a username" unless $username;

my $d  = DDGC->new;

my $user = $d->rs('User')->find({ username => $username });

die "user not found" unless $user;

my $ia = $d->rs('InstantAnswer')->find({lc id => $ia_name});

die "ia not found" unless $ia;

$ia->add_to_users($user);

print "User ".$username." can edit ". $ia_name . "\n";
