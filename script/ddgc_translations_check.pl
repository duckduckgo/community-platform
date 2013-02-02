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
	my @translations = $_->token_languages->search_related('token_language_translations');
	for (@translations) {
		my $msgid = $_->token_language->token->msgid;
		my $msgid_plural = $_->token_language->token->msgid_plural;
		unless (Locale::Simple::sprintf_compare(
			$_->token_language->token->msgid,
			$_->msgstr0
		)) {
			print "INVALID TOKEN\n";
		}
		for my $keyno (1..$_->msgstr_index_max) {
			my $key = 'msgstr'.$keyno;
			next unless $_->$key;
			unless (Locale::Simple::sprintf_compare(
				$_->token_language->token->msgid_plural,
				$_->$key
			)) {
				print "INVALID TOKEN\n";
			}
		}
	}
}

