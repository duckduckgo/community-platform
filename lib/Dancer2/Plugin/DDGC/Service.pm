package Dancer2::Plugin::DDGC::Service;

# ABSTRACT: Set default configuration and behaviour for JSON services.

use Dancer2;
use Dancer2::Plugin;

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

    $dsl->app->add_hook(
        Dancer2::Core::Hook->new(
            name => 'before_serializer',
            code => sub {
                my ( @data ) = @_;
                for my $datum (@data) {
                    $datum->{status} //= 200;
                    $datum->{ok}     //= 1;
                    if ( $datum->{status} >= 400 ) {
                        $datum->{ok} = 0;
                    }
                }
            },
        )
    );
};

register_plugin;

1;
