package DDGC::Schema::Role::Result::User::Subscription;
use strict;
use warnings;

use Moo::Role;


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

1;
