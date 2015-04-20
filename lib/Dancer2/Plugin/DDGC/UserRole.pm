package Dancer2::Plugin::DDGC::UserRole;

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

                redirect root_uri_for(
                    $settings->{redirect_url} || '/my/login'
                );
            }
            goto STATUS_403;
        }

        if ( !$user->is($role) ) {
            goto STATUS_403;
        }

        goto $coderef;

STATUS_403:
        $dsl->status(403);
        return {
            ok     => 0,
            status => 403,
            error  => '403 Forbidden',
        };
    };
};

register_plugin;

1;
