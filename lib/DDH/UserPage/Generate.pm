package DDH::UserPage::Generate;

use strict;
use warnings;

use Moo;
use Text::Xslate;
use File::Path qw/ make_path /;
use JSON::MaybeXS;
use Cwd qw/ abs_path /;
use Carp;

has view_dir => (
    is       => 'ro',
    required => 1,
    coerce   => sub { abs_path( $_[0] ) },
);

has build_dir => (
    is       => 'ro',
    required => 1,
    coerce   => sub {
        my $p = abs_path( $_[0] );
        make_path( $p );
        return $p;
    },
);

has contributors => (
    is       => 'ro',
    required => 1,
);

has xslate => ( is => 'lazy' );
sub _build_xslate {
    Text::Xslate->new( {
        path => [ $_[0]->view_dir ],
    } );
}

has json => ( is => 'lazy' );
sub _build_json {
    JSON::MaybeXS->new( utf8 => 1, pretty => 1 );
}

sub contributor_dir {
    my ( $self, $contributor ) = @_;
    my $p = abs_path(
        sprintf( '%s/%s', $self->build_dir, $contributor )
    );
    make_path( $p );
    return $p;
}

sub generate {
    my ( $self ) = @_;

    open my $fh, '>:encoding(UTF-8)', $self->build_dir . "/index.json" or die();
    print $fh $self->json->encode( $self->contributors );

    for my $contributor ( keys $self->contributors ) {
        if ( $contributor=~ /^https?:/ ) {
            warn "$contributor appears to be a URL - skipping";
            next;
        }
        my $build_dir = $self->contributor_dir( $contributor );

        open my $fh, '>:encoding(UTF-8)', "$build_dir/index.html" or die();
        print $fh $self->xslate->render(
            'userpage/index.tx',
            { data => $self->json->encode(
                $self->contributors->{ $contributor }
            ) }
        );
        close $fh;
    }
}

1;

