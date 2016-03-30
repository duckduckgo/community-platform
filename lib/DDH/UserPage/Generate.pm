package DDH::UserPage::Generate;

use strict;
use warnings;

use Moo;
use Text::Xslate;
use File::Path qw/ make_path /;
use JSON::MaybeXS;
use Cwd qw/ abs_path /;
use Carp;
use DDGC;
use DDH::UserPage::Gather;

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
    default  => sub {
        my ( $self ) = @_;
        my $index_json = $self->build_dir . "/index.json";

        # if index.json is older than 15 mins...
        if ( !-f $index_json || ( time - ( stat $index_json )[10] > 900 ) ) {
            return DDH::UserPage::Gather->new->contributors
        }
        else {
            local $/;
            open my $fh, '<:encoding(UTF-8)', $index_json or die;
            my $json = <$fh>;
            return $self->json->decode( $json );
        }
    }
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

has ddgc => ( is => 'lazy' );
sub _build_ddgc {
    DDGC->new;
}

has db => ( is => 'lazy' );
sub _build_db {
    $_[0]->ddgc->db;
}

has settings => ( is => 'lazy' );
sub _build_settings {
    +{
        ddgc_config => $_[0]->ddgc->config,
    }
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
    my $valid_contributors;

    open my $fh, '>:encoding(UTF-8)', $self->build_dir . "/index.json" or die();
    print $fh $self->json->encode( $self->contributors );
    close $fh;

    for my $contributor ( keys $self->contributors ) {
        if ( $contributor=~ /^https?:/ ) {
            warn "$contributor appears to be a URL - skipping";
            next;
        }

        my $build_dir = $self->contributor_dir( $contributor );
        my $contributor_data = $self->contributors->{ $contributor };

        # JSON dump of user's data
        open my $jfh, '>:encoding(UTF-8)', "$build_dir/index.json" or die();
        print $jfh $self->json->encode( $contributor_data );
        close $jfh;

        push @{ $valid_contributors }, $contributor;
    }

    open my $jfh, '>:encoding(UTF-8)', $self->build_dir. "/users.json" or die();
    print $jfh $self->json->encode( $valid_contributors );
    close $jfh;
}

1;

