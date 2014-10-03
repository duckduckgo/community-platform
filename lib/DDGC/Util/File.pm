package DDGC::Util::File;
# ABSTRACT: Utility functions for files

use strict;
use warnings;
use Exporter 'import';

our @EXPORT = qw(
	max_file_version
);


sub max_file_version {
    my ( $path, $base, $ext ) = @_;
    my $mx = 0;

    foreach my $srcver (<$path/$base*.$ext>) {
        if ($srcver =~ /$base(\d{1,})\.$ext/) { $mx = $1 if $1 > $mx; }
    }

    return $mx;
}


