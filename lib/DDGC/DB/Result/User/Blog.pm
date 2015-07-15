package DDGC::DB::Result::User::Blog;

# ABSTRACT: Result class of blog posts

use Moo;
extends 'DBIx::Class::Core';
use DBIx::Class::Candy;
use DateTime::Format::RSS;
use DDGC::Util::Markup;

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

column content => {
    data_type   => 'text',
    is_nullable => 0,
};

column topics => {
    data_type        => 'text',
    is_nullable      => 1,
    serializer_class => 'JSON',
};

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

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';

sub html_teaser {
    my ($self) = @_;
    my $format = $self->format;
    DDGC::Util::Markup->new->$format( $self->teaser );
}

sub u {
    my ($self) = @_;
    return sprintf "/blog/post/%s/%s", $self->id, $self->uri;
}

1;
