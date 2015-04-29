package DDGC::Schema::Result::User;
# ABSTRACT: Result class of a user in the DB

use Moo;
extends 'DDGC::Schema::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'users';

sub u_userpage {
    my ( $self ) = @_;
    return ['Root','default'] unless $self->public_username;
    return ['Userpage','home',$self->public_username];
}

column id => {
    data_type => 'bigint',
    is_auto_increment => 1,
};
primary_key 'id';

unique_column username => {
    data_type => 'text',
    is_nullable => 0,
};
sub lowercase_username { lc(shift->username) }
sub lc_username { lc(shift->username) }

column public => {
    data_type => 'int',
    is_nullable => 0,
    default_value => 0,
};

column email_notification_content => {
    data_type => 'int',
    is_nullable => 0,
    default_value => 1,
};

column admin => {
    data_type => 'int',
    is_nullable => 0,
    default_value => 0,
};

column ghosted => {
    data_type => 'int',
    is_nullable => 0,
    default_value => 1,
};

column ignore => {
    data_type => 'int',
    is_nullable => 0,
    default_value => 0,
};

column email => {
    data_type => 'text',
    is_nullable => 1,
};

column email_verified => {
    data_type => 'int',
    is_nullable => 0,
    default_value => 0,
};

column userpage => {
    data_type => 'text',
    is_nullable => 1,
    serializer_class => 'JSON',
};

column data => {
    data_type => 'text',
    is_nullable => 1,
    serializer_class => 'YAML',
};

column notes => {
    data_type => 'text',
    is_nullable => 1,
};

column profile_media_id => {
    data_type => 'bigint',
    is_nullable => 1,
};

column created => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
};

column updated => {
    data_type => 'timestamp with time zone',
    set_on_create => 1,
    set_on_update => 1,
};

column roles => {
    data_type => 'text',
    is_nullable => 1,
    default_value => '',
};

column flags => {
    data_type => 'text',
    is_nullable => 0,
    serializer_class => 'JSON',
    default_value => '[]',
};

# TODO: Migrate 'flags' to 'roles'
sub is {
    my ( $self, $role ) = @_;
    $role = 'forum_manager' if ( $role eq 'community_leader' );
    return 1 if ( $role eq 'user' );
    return 0 if !$role;
    return 1 if $self->admin;
    return 1 if grep { $_ eq $role } @{ $self->flags };
    return 0;
}

1;
