package DDGC::Web::Plugin::Service;

use Dancer2;
use Dancer2::Plugin;
use DDGC::Config;

on_plugin_import {
    my ( $dsl ) = @_;

    $dsl->set(serializer => 'JSON');

};

register_plugin for_versions => [2];

1;
