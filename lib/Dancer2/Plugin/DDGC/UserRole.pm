package Dancer2::Plugin::DDGC::UserRole;

# ABSTRACT: Authorisation for DDGC request handlers

use strict;
use warnings;

use Dancer2::Plugin;
use Carp;
use Hash::Merge::Simple qw/ merge /;

on_plugin_import {
    my ( $dsl ) = @_;
    die "Need to load Dancer2::Plugin::RootURIFor before Dancer2::Plugin::DDGC::UserRole" if !($dsl->can('root_uri_for'));
};

register user_is => sub {
    my ( $dsl, $role, @other ) = @_;
    confess "user_is requires role parameter" if !$role;

    my ( $opts, $coderef ) =
        ( ref $other[0] eq 'HASH' )
            ? @other
            : ({}, @other);

    my $settings = merge plugin_setting(), $opts;

     return sub {
        my $user = $dsl->vars->{user};

        if ( !$user ) {
            if ( $settings->{redirect} ) {

                $dsl->session->write( 'last_url', $dsl->request->uri )
                    if ( !$settings->{not_last_url} );

                $dsl->redirect( $dsl->root_uri_for (
                    $settings->{redirect_url} || '/my/login'
                ) );
            }
            goto STATUS_403;
        }

        if ( !$user->is($role) ) {
            goto STATUS_403;
        }

        goto $coderef;

STATUS_403:
        $dsl->status(403);
        my $status = {
            ok     => 0,
            status => 403,
            error  => '403 Forbidden',
        };
        return ( $settings->{error_template} )
            ? template $settings->{error_template}, $status
            : ( $dsl->config->{serializer} )
                ? $status
                : $status->{error};
    };
};

register_plugin;

1;

__END__

=pod

=head1 NAME

Dancer2::Plugin::DDGC::UserRole - Authorisation for your request handlers

=head1 SYNOPSIS

    use Dancer2;
    user Dancer2::Plugin::DDGC::UserRole;

    post '/admin/user/delete' => user_is 'admin' => sub {
        rset('User')->find( param('id') )->delete;
    }

=head1 DESCRIPTION

Dancer2::Plugin::DDGC::UserRole provides C<user_is> for your request handlers.

This guards the request against unauthorised usage and can (optionally) redirect
to a login page or return a 403 error.

=head1 CONFIGURATION

    plugins => {
        'DDGC::UserRole' => {
            redirect     => 1,
            redirect_url => '/my/login',
        }
    }

If there is no user logged in, we can optionally redirect them to the login page.
The current URL is stashed in the session and, after successful login, the user
is redirected back to this page.

To prevent the current route handler being stored as the redirect URL, you can
specify C<not_last_url>:

    get '/account' => user_is 'user', { not_last_url => 1 } => sub {
        ...

This can also be used to override configured behaviour:

    get '/admin' => user_is 'admin', { redirect_url => '/not_found' } => sub {
        ...

=head1 FUNCTIONS

=head2 user_is

This expects a user role and optionally a hashref with override options as
parameters. If authorisation is successful, execution is passed to the route
handler, otherwise we redirect or return a HTTP 403 response, depending on
configuration.

=head1 ROLES

Roles are defined in L<DDGC::Schema::Result::User>. For the purposes of
C<user_is>, we have the following roles.

=head2 user

Any user - equivalent to checking user is logged in.

=head2 forum_manager

Community Leader

=head2 community_leader

Community Leader

=head2 translation_manager

Translation Manager

=head2 admin

Staff

=cut
