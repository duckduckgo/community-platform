package DDGC::Web::Plugin::Config;

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

    $dsl->set(views => './');

    $dsl->set(
        engines  => {
            template => {
                Xslate => {
                    path      => $appdir . '/templates',
                    cache_dir => $config->xslate_cachedir,
                    function  => {
                        c => sub {
                                $dsl->request->vars;
                        },
                        u => sub { '/' },
                        next_template => sub {
                            my $templates = $dsl->request->var('templates');
                            my $template = shift @{$templates};
                            $dsl->request->var( templates => $templates );
                        }
                    },
                },
            }
        }
    );

    $dsl->set(template => 'Xslate');
};

register_plugin for_versions => [2];

1;
