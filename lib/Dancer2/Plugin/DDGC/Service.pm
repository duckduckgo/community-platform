package Dancer2::Plugin::DDGC::Service;

use Dancer2;
use Dancer2::Plugin;
use DDGC::Config;

on_plugin_import {
    my ( $dsl ) = @_;

    $dsl->set(
        engines  => {
            %{ $dsl->config->{engines} },
            serializer => {
                JSON => {
                    convert_blessed => 1,
                    utf8            => 1,
                },
            }
        }
    );

    $dsl->set(serializer => 'JSON');

    $dsl->set(
        plugins => {
            %{ $dsl->config->{plugins} },
            'DDGC::UserRole' => {
                redirect => 0,
            }
        }
    );
};

register_plugin;

1;
