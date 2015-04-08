package DDGC::Web::Plugin::Session;

use Dancer2;
use Dancer2::Plugin;
use DDGC::Config;

on_plugin_import {
    my ( $dsl ) = @_;
    die "No schema method in app. Did you load DBIC::Plugin::DBIC before DDGC::Web::Plugin::Session?" if !( $dsl->can('schema'));

    my $schema = $dsl->schema;
    my $settings = plugin_setting();

    for (qw/delete get head options patch post put/) {

        $dsl->app->add_route(
            method => $_,
            regexp  => qr/.*/,

            code    => sub {
                my ($app) = @_;
                $dsl->request->var( user =>
                    $schema->resultset('User')->find(
                        { username => $dsl->session('__user') }
                    )
                );
                $dsl->pass;
            },

        );

    }

};

register_plugin for_versions => [2];

1;
