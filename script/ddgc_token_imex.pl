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

GetOptions(
	"domain=s" => \$domain,
	"import=s" => \$import,
	"export=s" => \$export,
	"dry" => \$dry,
);

die 'you must do one: --import from a file or --export to a file' if ( ( $import && $export ) || ( !$import && !$export ) );

die 'export doesnt support dryrun' if $export && $dry;

die 'you must give a --domain' if !$domain;

my $schema = DDGC->new->db;

my $td = $schema->resultset('Token::Domain')->search({ key => $domain },{ prefetch => 'tokens' })->next;

die 'token domain "'.$domain.'" not found' if !$td;

my @ts = $td->tokens;

# IMPORT
if ($import) {

	my @im = @{decode_json(io($import)->slurp)};

	for (@im) {

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
				$td->create_related('tokens',$_);
			}
		}

	}

# EXPORT
} else {

	my @ex;

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