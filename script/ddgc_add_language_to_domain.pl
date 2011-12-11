#!/usr/bin/perl

use utf8;
use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use DDGC::DB;

my $locale = shift @ARGV;
my $domain = shift @ARGV;

die "You must give locale and domain (in this order) as parameter" if !$domain || !$locale;

my $schema = DDGC::DB->connect;

my $td = $schema->resultset('Token::Domain')->search({ key => $domain })->next;

die 'token domain "'.$domain.'" not found' if !$td;

my $lang = $schema->resultset('Language')->search({ locale => $locale })->next;

die 'language "'.$locale.'" not found' if !$lang;

my $tdl = $td->create_related('token_domain_languages',{
	language => $lang,
});

if ($tdl) {
	print 'Successfully added "'.$locale.'" to "'.$domain.'".'."\n";
} else {
	print 'Failure on adding "'.$locale.'" to "'.$domain.'".'."\n";
}
