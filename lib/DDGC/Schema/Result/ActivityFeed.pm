package DDGC::Schema::Result::ActivityFeed;
# ABSTRACT: Activity feed reault class

use Moo;
extends 'DDGC::Schema::Result';
with 'DDGC::Schema::Role::Result::ActivityFeed::AdvancedDescription';

use DBIx::Class::Candy;
use DDGC::Util::Markup;

table 'activity_feed';


=pod

=head1 NAME

DDGC::Schema::Result::ActivityFeed - interface to community platform activity feed

=head1 SYNOPSIS

    rset('ActivityFeed')->create({
        category => 'ia',
        action   => 'updated',
        meta1    => $ia->name,
        meta2    => $self->topics->join_for_activity_meta( 'name' ),
        description => sprintf( 'Instant answer [%s updated](%s)',
                        $ia->name, $ia->url ),
    });


    rset('ActivityFeed')->create({
        category => 'forum',
        action   => 'moderate',
        for_role => $self->app->config->id_for_role('forum_manager'),
        description => sprintf( '[%d new comments for moderation](https:...)',
                        $moderation_count ),
    });

=head1 COLUMNS

=cut

column id => {
    data_type => 'bigint',
    is_auto_increment => 1,
};
primary_key 'id';

column created => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
};

=head2 category

Category is the top-level community-platform function which generated this
activity. Potential examples:

=over

=item comment

=item translation

=item instant_answer

=back

=cut

column category => {
    data_type => 'text',
    is_nullable => 0,
};

=head2 action

Action is a top-level description of the activity which occurred. Potential
examples:

=over

=item created

=item update

=item moderate

=back

=cut

column action => {
    data_type => 'text',
    is_nullable => 0,
    default_value => 'created',
};

=head2 meta1, meta2, meta3

Meta allows you to attach arbitrary additional information for subscribers,
such as categories, titles or tags.

For example, if you descide to store IA name in in meta1, a subscription can
follow all activity on a given IA with:

    +{
        category => 'ia',
        meta1    => 'pokemon',
    }

=cut

column meta1 => {
    data_type => 'text',
    is_nullable => 1,
};

column meta2 => {
    data_type => 'text',
    is_nullable => 1,
};

column meta3 => {
    data_type => 'text',
    is_nullable => 1,
};

=head2 description

Description is a piece of text describing your activity for email and web
publishing.

=cut

column description => {
    data_type => 'text',
    is_nullable => 0,
};

=head2 format

The format of your description. This is currently rendered by DDGC::Util::Markup,
so supported formats are:

=over

=item bbcode

=item markdown

=item html

=back

The default format is markdown. Other formats will be rendered as plain text.

=cut

column format => {
    data_type => 'text',
    default_value => 'markdown',
};

=head2 for_user

This activity is for a specific user, e.g. a reply to a comment or @ mention.

=cut

column for_user => {
    data_type => 'bigint',
    is_nullable => 1,
};

=head2 for_role

This activity is for a given role, e.g. admin, community_leader.

Role IDs are defined in DDGC::Config::roles

=cut

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
    return $self->renderer->$format( $self->description ) if
        $self->renderer->can($format);
    return sprintf '<pre>%s</pre>', $self->description;
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
