package Dancer2::Plugin::DDGC::Config;

use Dancer2;
use Dancer2::Plugin;
use DDGC::Config;

on_plugin_import {
    my ( $dsl ) = @_;
    my $settings = plugin_setting();
    my $config = DDGC::Config->new;
    my $appdir = $dsl->config->{appdir};

    $dsl->set(ddgc_config => $config);

    $dsl->set(
        plugins => {
            %{ $dsl->config->{plugins} },
            DBIC => {
                default => {
                    dsn          => $config->db_dsn,
                    user         => $config->db_user,
                    password     => $config->db_password,
                    schema_class => 'DDGC::Schema',
                }
            },
        },
    );

    $dsl->set(session => 'PSGI');

    $dsl->set(layout => 'main');
    $dsl->set(views => './');

    $dsl->set(
        engines  => {
            %{ $dsl->config->{engines} },
            template => {
                Xslate => {
                    path      => 'views',
                    cache_dir => $config->xslate_cachedir,
                },
            }
        }
    );

    $dsl->set(template => 'Xslate');
};

register_plugin;

1;
