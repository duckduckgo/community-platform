package DDGC::Util::Po;

use strict;
use warnings;
use Exporter 'import';
use Locale::PO::Callback;

our @EXPORT = qw(
	read_po_file
	token_key
	token_hash
);

sub token_key {
	my ( $po ) = @_;
	die __PACKAGE__.': No msgid found in hash' unless defined $po->{msgid};
	my @key_parts = ('msgid:'.$po->{msgid});
	push @key_parts, 'msgid_plural:'.$po->{msgid_plural} if defined $po->{msgid_plural};
	push @key_parts, 'msgctxt:'.$po->{msgctxt} if defined $po->{msgctxt};
	return join('|||',@key_parts);
}

sub token_hash {
	my ( @tokens ) = @_;
	my %hash;
	for (@tokens) {
		$hash{token_key($_)} = $_;
	}
	return \%hash;
}

sub read_po_file {
	my ( $po_file ) = @_;

	my %po_entries;
	my $lpc = Locale::PO::Callback->new(sub {
		my ( $po ) = @_;
		return unless defined $po->{msgid};
		if (defined $po_entries{token_key($po)}) {
			if (defined $po->{locations}) {
				$po_entries{token_key($po)}->{locations} = [] unless defined $po_entries{token_key($po)}->{locations};
				push @{$po_entries{token_key($po)}->{locations}}, @{$po->{locations}};
			}
		} else {
			$po_entries{token_key($po)} = $po;
		}
	});
	$lpc->read($po_file);

	my @entries;
	for (sort { $a cmp $b } keys %po_entries) {
		push @entries, $po_entries{$_};
	}

	return \@entries;
}

1;