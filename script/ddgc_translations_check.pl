#!/usr/bin/env perl

$|=1;

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use DDGC::DB;
use Getopt::Long;
use JSON;
use DDGC;
use Locale::Simple;
use utf8;

my $domain;

GetOptions(
	"domain=s" => \$domain,
);

die 'you must give a --domain' if !$domain;

my $schema = DDGC::DB->connect(DDGC->new);

my $td = $schema->resultset('Token::Domain')->search({ key => $domain },{ prefetch => 'token_domain_languages' })->next;

die 'token domain "'.$domain.'" not found' if !$td;

my @tdls = $td->token_domain_languages;

for (@tdls) {
	my @translations = $_->token_languages->search_related('token_language_translations',{
		check_timestamp => undef,
	});
	$_->force_check for (@translations);
}

