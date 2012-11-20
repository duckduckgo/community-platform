#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use DDGC;

my $ddgc = DDGC->new;
my $schema = $ddgc->db;

my @languages = $schema->resultset('Language')->search({},{ order_by => 'id' });

print '
map $http_accept_language $http_accept_language_locale {
';

for (@languages) {
	my $locale_accept_language = $_->locale;
	$locale_accept_language =~ s/_/-/;
	print "\t".'~^'.$locale_accept_language.' '.$_->locale.";\n";
}

my %langonly;

for (@languages) {
	my @parts = split(/_/,$_->locale);
	next if $langonly{$parts[0]};
	$langonly{$parts[0]} = 1;
	print "\t".'~^'.$parts[0].' '.$_->locale.";\n";
}

print '}

';
