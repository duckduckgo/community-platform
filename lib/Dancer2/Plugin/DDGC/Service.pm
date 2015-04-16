package Dancer2::Plugin::DDGC::Service;

use Dancer2;
use Dancer2::Plugin;
use DDGC::Config;

on_plugin_import {
    my ( $dsl ) = @_;

    $dsl->set(
        engines  => {
            serializer => {
                JSON => {
                    convert_blessed => 1,
                },
            }
        }
    );

    $dsl->set(serializer => 'JSON');

};

register_plugin for_versions => [2];

1;
