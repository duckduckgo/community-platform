package DDGC::Schema::Role::Result::ActivityFeed::AdvancedDescription;
use strict;
use warnings;

use Moo::Role;

has xslate => (
    is => 'ro',
    lazy => 1,
    builder => '_build_xslate',
);
sub _build_xslate {
    Text::Xslate->new(
        path => 'views',
    );
}

sub describe {
    my ( $self ) = @_;
    my $sub = sprintf 'describe_%s',
                join( '_', ( $self->category, $self->action ) );

    return $self->$sub if $self->can( $sub );
    return $self->render_description;
}

1;
