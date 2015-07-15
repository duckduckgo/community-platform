package DDGC::Schema::Result::User;

# ABSTRACT: DDGC User Result class

use Moo;
extends 'DDGC::Schema::Result';
use DBIx::Class::Candy;
use Scalar::Util qw/ looks_like_number /;
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

# TODO: Make this JSON or anything else
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

has_many 'roles', 'DDGC::Schema::Result::User::Role', 'users_id';

sub is {
    my ( $self, $role ) = @_;
    return 0 if !$role;
    return 1 if ( $role eq 'user' );
    return 1 if $self->roles->find({
        role => $self->app->config->{ddgc_config}->id_for_role('admin')
    });
    return 1 if $self->roles->find({
        role => $self->app->config->{ddgc_config}->id_for_role($role)
    });
    return 0;
}

sub unread_notifications {
    0;
}

sub remove_role {
    my ( $self, $role ) = @_;
    return $self->update({ admin => 0 }) if $role eq 'admin';
    $role = 'forum_manager' if ( $role eq 'community_leader' );
    return 0 if grep { $_ eq $role } @{$self->flags};
    my @roles = grep { $_ ne $role } @{$self->flags};
    $self->update({ flags => \@roles });
}

sub add_role {
    my ( $self, $role ) = @_;
    return $self->update({ admin => 1 }) if $role eq 'admin';
    $role = 'forum_manager' if ( $role eq 'community_leader' );
    return 0 if grep { $_ eq $role } @{$self->flags};
    push @{$self->flags}, $role;
    $self->update;
}

sub username_filesystem_clean {
    my ( $self ) = @_;
    ( my $n = $self->username ) =~ s/[^A-Za-z0-9_-]+/_/g;
    return $n;
}

sub avatar_path {
    my ( $self, $size ) = @_;
    my $username = $self->username_filesystem_clean;
    my $fn = '/media/avatar/' . join '/', (
        ( split '', $username )[0..1],
        $username,
    );
    return $fn . (( $size )
        ? "/${username}_${size}"
        : '');
}

sub avatar {
    my ( $self, $size ) = @_;
    return '/static/images/profile.anonymous.png' if ( !$self->public );
    $size ||= 32;
    $size = 32 if ( !looks_like_number( $size ) );
    my $avatar = $self->avatar_path( $size );
    my $fullpath = join '/', ($self->app->config->{ddgc_config}->rootdir, $avatar);
    return '/static/images/profile.male.png' if ( !-f $fullpath );
    return $avatar;
}

sub badge {
    my ( $self ) = @_;
    for my $role (qw/ admin community_leader translation_manager /) {
        return $role if $self->is($role)
    }
    return '';
}

sub TO_JSON {
    my ( $self ) = @_;
    return []
      if ( !$self->public
        && !( $self->app->var('user') && ( $self->app->var('user')->is('admin')
                                        || $self->app->var('user')->id == $self->id ))
      );

    +{
        id          => $self->id,
        username    => $self->username,
        avatar16    => $self->avatar(16),
        avatar32    => $self->avatar(32),
        avatar48    => $self->avatar(48),
        public      => $self->public,
        badge       => $self->badge,
    };
}

1;
