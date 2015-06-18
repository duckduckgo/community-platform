use strict;
use warnings;
package DDGC::Util::TemplateHelpers;
# ABSTRACT: Convenience helper functions for use in templates.

# There are some things which are nice to have in templates.
# Keep this class small, just the essentials.

use Data::Pageset;

use Moo;

has app => (
    is => 'ro',
);

sub uri_for {
    my ( $self ) = shift;
    $self->app->root_uri_for(@_);
}

sub pager {
    my ( $self, $page, $pages ) = @_;
    Data::Pageset->new( {
        total_entries       => $pages,
        entries_per_page    => 1,
        current_page        => $page,
        pages_per_set       => 6,
        mode                => 'slide',
    } );
}

sub functions {
    my ( $self ) = @_;
    +{
        uri_for => sub { $self->uri_for(@_) },
        pager => sub { $self->pager(@_) },
    };
}

1;
