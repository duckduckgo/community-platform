package DDGC::Schema::Result::ActivityFeed;
# ABSTRACT: Activity feed reault class

use Moo;
extends 'DDGC::Schema::Result';
use DBIx::Class::Candy;
use DDGC::Util::Markup;

table 'activity_feed';

column id => {
    data_type => 'bigint',
    is_auto_increment => 1,
};
primary_key 'id';

column created => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
};

column description => {
    data_type => 'text',
    is_nullable => 0,
};

column format => {
    data_type => 'text',
    default_value => 'markdown',
};

column for_user => {
    data_type => 'bigint',
    is_nullable => 1,
};

column for_role => {
    data_type => 'int',
    is_nullable => 1,
};

has renderer => (
    is => 'ro',
    lazy => 1,
    builder => '_build_renderer',
);
sub _build_renderer {
    DDGC::Util::Markup->new;
}

sub render_description{
    my ( $self ) = @_;
    my $format = $self->format || 'markdown';
    $self->renderer->$format( $self->description );
}

sub TO_JSON {
    my ( $self ) = @_;
    +{
        id          => $self->id,
        type        => $self->type,
        created     => $self->created->epoch,
        description => $self->render_description,
        raw_description => $self->description,
    }
}

1;
