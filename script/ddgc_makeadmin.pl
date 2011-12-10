#!/usr/bin/perl

use utf8;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use DDGC::DB;

my $username = shift @ARGV;

die "please give a username" unless $username;

my $schema = DDGC::DB->connect;

my $user = $schema->resultset('User')->find({ username => $username });

die "user not found" unless $user;

$user->admin(1);
$user->update;

print "User ".$username." is now admin...\n";
