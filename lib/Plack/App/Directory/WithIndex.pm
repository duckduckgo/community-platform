package Plack::App::Directory::WithIndex;
use parent qw(Plack::App::Directory);
use strict;
use warnings;

use Plack::Util::Accessor qw( index );

sub serve_path {
    my($self, $env, $dir, $fullpath) = @_;

    my $idx_files = ( $self->index )
        ? ( ( ref $self->index eq 'ARRAY' )
            ? $self->index
            : [ $self->index ] )
        : [ qw( index.html index.htm ) ];

    if ( -d $dir ) {
        for my $file ( @{ $idx_files } ) {
            my $idx_path = sprintf( '%s/%s', $dir, $file );
            if ( -f $idx_path ) {
                $dir = $idx_path;
            }
        }
    }

    return $self->SUPER::serve_path($env, $dir, $fullpath);
}

1;

