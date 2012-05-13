#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use Getopt::Long;
use JSON;
use IO::All -utf8;
use Locale::PO::Callback;

my $target;
my $po;
my $type = 1;

GetOptions(
	"po=s" => \$po,
	"target=s" => \$target,
	"type=i" => \$type,
);

die 'you must do: --po filename.po --target token-import.json' if ( !$po || !$target );

my %po_entries;
 
my $lpc = Locale::PO::Callback->new(sub {
	my ( $po ) = @_;
	return if defined $po->{type} && $po->{type} eq 'header';
	my $key = join('|||',
		$po->{msgid},
		defined $po->{msgid_plural} ? $po->{msgid_plural} : (),
		defined $po->{msgctxt} ? $po->{msgctxt} : ());
	unless(defined $po_entries{$key}) {
		$po_entries{$key} = $po;
	}
});
$lpc->read($po);

my @entries;

for (sort { $a cmp $b } keys %po_entries) {
	push @entries, {
		msgid => $po_entries{$_}->{msgid},
		type => $type,
		defined $po_entries{$_}->{msgid_plural} ? (msgid_plural => $po_entries{$_}->{msgid_plural}) : (),
		defined $po_entries{$_}->{msgctxt} ? (msgctxt => $po_entries{$_}->{msgctxt}) : (),
	};
}

io($target)->print(encode_json(\@entries));
