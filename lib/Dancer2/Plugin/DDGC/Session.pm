package Dancer2::Plugin::DDGC::Session;

# ABSTRACT: Populates request variable 'user' with instance of user from Plack session

use Dancer2;
use Dancer2::Plugin;
use Data::UUID;
use Digest::MD5 qw/ md5_hex /;

on_plugin_import {
    my ( $dsl ) = @_;
    die "No schema method in app. Did you load DBIC::Plugin::DBIC before DDGC::Web::Plugin::Session?" if !( $dsl->can('schema'));

    my $schema = $dsl->schema;

    $dsl->app->add_hook(
        Dancer2::Core::Hook->new(
            name => 'before',

            code => sub {
                $dsl->var( user =>
                    $schema->resultset('User')->find(
                        { username => $dsl->session('__user') || undef }
                    )
                );
                if ( !$dsl->session('action_token') ) {
                    $dsl->session(
                        action_token =>
                        md5_hex( Data::UUID->new->create_str . rand )
                    );
                }
            },
        )
    );

};

register_plugin;

1;
