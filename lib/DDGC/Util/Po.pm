package DDGC::Util::Po;

use strict;
use warnings;
use Exporter 'import';
use Locale::PO::Callback;

our @EXPORT = qw( read_po_file );

sub read_po_file {
	my ( $po_file ) = @_;

	my %po_entries;
	my $lpc = Locale::PO::Callback->new(sub {
		my ( $po ) = @_;
		return unless defined $po->{msgid};
		my @key_parts = ($po->{msgid});
		push @key_parts, $po->{msgid_plural} if defined $po->{msgid_plural};
		push @key_parts, 'msgctxt___'.$po->{msgctxt} if defined $po->{msgctxt};
		my $key = join('|||',@key_parts);
		unless(defined $po_entries{$key}) {
			$po_entries{$key} = $po;
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