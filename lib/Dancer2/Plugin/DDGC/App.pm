package Dancer2::Plugin::DDGC::App;

# ABSTRACT: Set default configuration for Application services.

use Dancer2::Plugin;

on_plugin_import {
    my ( $dsl ) = @_;

    $dsl->set(
        plugins => {
            %{ $dsl->config->{plugins} },
            'DDGC::UserRole' => {
                redirect     => 1,
                redirect_url => '/my/login',
            }
        }
    );

};

register_plugin;

1;
