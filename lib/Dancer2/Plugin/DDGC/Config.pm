package Dancer2::Plugin::DDGC::Config;

# ABSTRACT: Set common configuration options

use Dancer2;
use Dancer2::Plugin;
use DDGC::Config;
use DDGC::Util::TemplateHelpers;

my $nosession;

sub import {
    shift;
    $nosession = grep { $_ eq 'nosession' } @_;
}

on_plugin_import {
    my ( $dsl ) = @_;
    my $settings = plugin_setting();
    my $config = DDGC::Config->new;
    my $appdir = $dsl->config->{appdir};

    $dsl->set(ddgc_config => $config);
    $dsl->set(charset => 'UTF-8');

    if ( $config->is_live ) {
        $dsl->set( environment => 'production' );
    }
    elsif ( $config->is_view ) {
        $dsl->set( environment => 'staging' );
    }

    if ( !$nosession ) {
        $dsl->set(
            engines  => {
                ( $dsl->config->{engines} )
                ? %{ $dsl->config->{engines} }
                : (),
                session => {
                    PSGI => {
                        cookie_name => 'ddgc_session',
                    },
                },
            }
        );
        $dsl->set(session => 'PSGI');
    }

    my $dsn_cfgs = {
       'Pg' => {
            options => {
                pg_enable_utf8 => 1,
                on_connect_do => [
                    "SET client_encoding to UTF8",
                ],
                quote_char => '"',
            },
       },
       'SQLite' => {
           options => {
               sqlite_unicode => 1,
           }
       },
    };

    (my $rdbms = $config->db_dsn) =~ s/dbi:([a-zA-Z]+):.*/$1/;


    $dsl->set(
        plugins => {
            %{ $dsl->config->{plugins} },
            DBIC => {
                default => {
                    dsn          => $config->db_dsn,
                    user         => $config->db_user,
                    password     => $config->db_password,
                    schema_class => 'DDGC::Schema',
                    %{ $dsn_cfgs->{ $rdbms } },
                }
            },
        },
    );

    $dsl->set(layout => 'main');
    $dsl->set(views => './');

    $dsl->set(
        engines  => {
            ( $dsl->config->{engines} )
            ? %{ $dsl->config->{engines} }
            : (),
            template => {
                Xslate => {
                    path      => 'views',
                    cache_dir => $config->xslate_cachedir,
                    cache     => 1,
                    function  =>
                        DDGC::Util::TemplateHelpers->new(
                            app => $dsl
                        )->functions,
                },
            }
        }
    );

    $dsl->set(template => 'Xslate');
};

register_plugin;

1;
