package Dancer2::Plugin::DDGC::Session;

use Dancer2;
use Dancer2::Plugin;
use DDGC::Config;

on_plugin_import {
    my ( $dsl ) = @_;
    die "No schema method in app. Did you load DBIC::Plugin::DBIC before DDGC::Web::Plugin::Session?" if !( $dsl->can('schema'));

    my $schema = $dsl->schema;
    my $settings = plugin_setting();

    $dsl->app->add_hook(
        Dancer2::Core::Hook->new(
            name => 'before',

            code => sub {
                $dsl->request->var( user =>
                    $schema->resultset('User')->find(
                        { username => $dsl->session('__user') || undef }
                    )
                );
            },

        )
    );

};

register_plugin for_versions => [2];

1;
