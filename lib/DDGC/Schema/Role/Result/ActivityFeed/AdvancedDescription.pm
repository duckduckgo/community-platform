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

sub describe_instant_answer_updated {
    my ( $self ) = @_;
    my $updates = { map { split ',', $_, 2 } ( $self->meta3 =~ /:(.*?):/g ) };

    $self->xslate->render(
        'includes/activity_feed/instant_answer_updated.tx', {
            activity => $self,
            updates  => join( ', ', keys $updates ),
        }
    );
}

1;
