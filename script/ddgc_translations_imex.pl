#!/usr/bin/perl

use utf8::all;
use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use DDGC::DB;
use Getopt::Long;
use JSON;
use IO::All -utf8;

my $username;
my $domain;
my $locale;
my $import;
my $export;

GetOptions(
	"user=s" => \$username,
	"domain=s" => \$domain,
	"locale=s" => \$locale,
	"import=s" => \$import,
	"export=s" => \$export
);

die 'you must do one: --import from a file or --export to a file' if ( ( $import && $export ) || ( !$import && !$export ) );

die 'you must give a --domain and a --locale' if !$domain || !$locale;

# TODO also cover im/ex of used translations
die 'we need a --user' if !$username;

my $schema = DDGC::DB->connect;

my $td = $schema->resultset('Token::Domain')->search({ key => $domain },{ prefetch => 'token_domain_languages' })->next;

die 'token domain "'.$domain.'" not found' if !$td;

my @tdls = $td->token_domain_languages;

my $tdl;

for (@tdls) {
	$tdl = $_ if $_->language->locale eq $locale;
}

my $user;
if ($username) {
	$user = $schema->resultset('User')->find({ username => $username });
	die 'user "'.$user.'" not found' if !$user;
}

die 'no language "'.$locale.'" in token domain "'.$domain.'"' if !$tdl;

# IMPORT
if ($import) {

	my @im = @{decode_json(io($import)->slurp)};

	for (@im) {
	
		my $t = $td->search_related('tokens',{
			msgid => delete $_->{msgid},
			msgid_plural => delete $_->{msgid_plural},
			msgctxt => delete $_->{msgctxt},
		})->next;

		if ($t) {
			my $tl = $t->search_related('token_languages',{ token_domain_language_id => $tdl->id })->next;
			$tl->update_or_create_related('token_language_translations',{
				%{$_},
				user => $user,
			},{
				key => 'token_language_translation_token_language_id_username',
			});
		} else {
			warn 'can\'t find a token';
		}

	}

# EXPORT
} else {

	my @ex;

	my @translations = $tdl->token_languages->search_related('token_language_translations',{ 
		username => $username,
	});
	
	for (@translations) {
		my $tlt = $_;
		my %translation;
		$translation{msgid} = $tlt->token_language->token->msgid;
		$translation{msgid_plural} = $tlt->token_language->token->msgid_plural if $tlt->token_language->token->msgid_plural;
		$translation{msgctxt} = $tlt->token_language->token->msgctxt if $tlt->token_language->token->msgctxt;
		my $msgstr_exist;
		for (0..$_->msgstr_index_max) {
			my $key = 'msgstr'.$_;
			if ($tlt->$key) {
				$translation{$key} = $tlt->$key;
				$msgstr_exist = 1;
			}
		}
		push @ex, \%translation if $msgstr_exist;
	}
	
	io($export)->print(encode_json(\@ex));

}