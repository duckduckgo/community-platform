package DDGC::Web::Plugin::Config;

use Dancer2;
use Dancer2::Plugin;
use DDGC::Config;

on_plugin_import {
    my ( $dsl ) = @_;
    my $settings = plugin_setting();
    my $config = DDGC::Config->new;

    $dsl->set(
        plugins => {
            DBIC => {
                default => {
                    dsn         => $config->db_dsn,
                    user        => $config->db_user,
                    password    => $config->db_password,
                }
            },
        },
    );
    $dsl->set(session => 'PSGI');
};

register_plugin for_versions => [2];

1;
