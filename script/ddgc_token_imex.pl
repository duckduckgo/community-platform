#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use Getopt::Long;
use JSON;
use IO::All -utf8;
use DDGC;
use DDP;

my $domain;
my $import;
my $export;
my $dry;
my $overview;

GetOptions(
	"domain=s" => \$domain,
	"import=s" => \$import,
	"export=s" => \$export,
	"dry" => \$dry,
	"overview" => \$overview,
);

die 'you must do one: --import from a file or --export to a file' if ( ( $import && $export ) || ( !$import && !$export ) );

die 'export doesnt support dry or overview' if $export && ( $dry || $overview );

$dry = 1 if $overview;

die 'you must give a --domain' if !$domain;

my $schema = DDGC->new->db;

my $td = $schema->resultset('Token::Domain')->search({ key => $domain },{ prefetch => 'tokens' })->next;

die 'token domain "'.$domain.'" not found' if !$td;

# IMPORT
if ($import) {

	my %entries;

	my @im = @{decode_json(io($import)->slurp)};

	for (@im) {

		my $key = join('|||',
			$_->{msgid},
			defined $_->{msgid_plural} ? $_->{msgid_plural} : (),
			defined $_->{msgctxt} ? $_->{msgctxt} : ());

		my $t = $td->search_related('tokens',{
			msgid => $_->{msgid},
			msgid_plural => $_->{msgid_plural},
			msgctxt => $_->{msgctxt},
		})->next;

		if ($t) {
			print "\nFollowing Token already exist:\n\n";
			p(%{$_});
		} else {
			if ($dry) {
				print "\nDRY RUN, WOULD ADD:\n\n";
				p(%{$_});
			} else {
				$t = $td->create_related('tokens',$_);
			}
		}

		$entries{$key} = 1 unless defined $entries{$key};

	}

	if ($overview) {
		print "\n============= OVERVIEW ================\n\n";
		for (sort { lc($a) cmp lc($b) } keys %entries) {
			print $_."\n";
		}
	}

# EXPORT
} else {

	my @ex;
	my @ts = $td->tokens;

	for (@ts) {
		my %token;
		$token{msgid} = $_->msgid;
		$token{msgid_plural} = $_->msgid_plural if $_->msgid_plural;
		$token{msgctxt} = $_->msgctxt if $_->msgctxt;
		$token{type} = $_->type;
		$token{data} = $_->data if $_->data;
		push @ex, \%token;
	}
	
	io($export)->print(encode_json(\@ex));

}