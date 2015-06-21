package DDGC::Schema::Result::User::Blog;

# ABSTRACT: Result class of blog posts

use Moo;
extends 'DDGC::Schema::Result';
use DBIx::Class::Candy;
use DateTime::Format::RSS;
use DDGC::Util::Markup;
use DDGC::Util::DateTime qw/ dur /;

table 'user_blog';

column id => {
    data_type         => 'bigint',
    is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
    data_type   => 'bigint',
    is_nullable => 0,
};

column title => {
    data_type   => 'text',
    is_nullable => 0,
};

column uri => {
    data_type   => 'text',
    is_nullable => 0,
};

column teaser => {
    data_type   => 'text',
    is_nullable => 0,
};

sub html_teaser {
    my ($self) = @_;
    my $markup = DDGC::Util::Markup->new;
    my $format = $self->format;
    return $markup->$format( $self->teaser );
}

column content => {
    data_type   => 'text',
    is_nullable => 0,
};

sub html {
    my ($self) = @_;
    my $markup = DDGC::Util::Markup->new;
    my $format = $self->format;
    return $markup->$format( $self->content );
}

column topics => {
    data_type        => 'text',
    is_nullable      => 1,
    serializer_class => 'JSON',
};

# TODO: Deprecate this
column company_blog => {
    data_type     => 'int',
    is_nullable   => 0,
    default_value => 0,
};

column format => {
    data_type     => 'varchar(8)',
    is_nullable   => 0,
    default_value => 'markdown',
};

column live => {
    data_type          => 'int',
    is_nullable        => 0,
    default_value      => 0,
    keep_storage_value => 1,
};

column seen_live => {
    data_type     => 'int',
    is_nullable   => 0,
    default_value => 0,
};

column fixed_date => {
    data_type   => 'timestamp with time zone',
    is_nullable => 1,
};

column created => {
    data_type     => 'timestamp with time zone',
    set_on_create => 1,
};

column updated => {
    data_type     => 'timestamp with time zone',
    set_on_create => 1,
    set_on_update => 1,
};

belongs_to 'user', 'DDGC::Schema::Result::User', 'users_id';

has_many comments => 'DDGC::Schema::Result::Comment', sub {
    my $args = shift;

    +{
        # TODO : simplify contexts like this to, e.g. 'blog'
        "$args->{foreign_alias}.context"    => 'DDGC::DB::Result::User::Blog',
        "$args->{foreign_alias}.context_id" => {
            -ident => "$args->{self_alias}.id"
        },
    }
};

sub date {
    my ($self) = @_;
    return $self->fixed_date if $self->fixed_date;
    return $self->created;
}

sub for_edit {
    my ($self) = @_;
    +{
        id      => $self->id,
        title   => $self->title,
        uri     => lc( $self->uri ),
        teaser  => $self->teaser,
        content => $self->content,
        $self->topics
            ? ( topics => join( ', ', @{ $self->topics } ) )
            : (),
        format => $self->format,
        $self->fixed_date
            ? ( fixed_date =>
              DateTime::Format::RSS->new->format_datetime(
                  $self->fixed_date
              ) )
            : (),
        live         => $self->live,
        company_blog => $self->company_blog,
    };
}

sub human_duration_updated {
    my ($self) = @_;
    my $result =
      DateTime::Format::Human::Duration->new->format_duration(
        DateTime->now - $self->updated );
    return ( split /,/, $result )[0];
}

sub TO_JSON {
    my ( $self ) = @_;
    my $date = $self->date;
    +{
        id      => $self->id,
        user_id => $self->users_id,
        user    => $self->user->TO_JSON,
        title   => $self->title,
        topics  => $self->topics,
        uri     => $self->uri,
        content => $self->html,
        teaser  => $self->html_teaser,
        path    => "/blog/post/" . $self->id . "/"  .$self->uri,
        date_m  => $date->month_abbr,
        date_d  => $date->day,
        dur     => dur( $date ),
        comment_count => $self->comments->ghostbusted->count,
    };
}

1;
