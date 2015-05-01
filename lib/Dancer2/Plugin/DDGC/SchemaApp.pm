package Dancer2::Plugin::DDGC::SchemaApp;

# ABSTRACT: Set schema's app instance to current app.

use Dancer2;
use Dancer2::Plugin;

on_plugin_import {
    my ( $dsl ) = @_;
    die "No schema method in app. Did you load DBIC::Plugin::DBIC before DDGC::Web::Plugin::SchemaApp?" if !( $dsl->can('schema'));
    $dsl->schema->can('app') && $dsl->schema->app($dsl);
};

register_plugin;

1;
