package Dancer2::Plugin::DDGC::Validate;

use Dancer2;
use Dancer2::Plugin;
use HTTP::Validate qw/ :validators /;

on_plugin_import {
    my ( $dsl ) = @_;
    my $app = $dsl->app;
    $app->{validator} = HTTP::Validate->new( ignore_unrecognized => 1 );

    $app->{validator}->define_ruleset(
        '/blog.json' =>
        { optional => 'page', valid => POS_VALUE, default => 1 },
        { optional => 'pagesize', valid => INT_VALUE(1,20), default => 20 },
    );
    $app->{validator}->define_ruleset(
        '/blog.json/post' =>
        { param => 'id', valid => POS_VALUE },
    );
    $app->{validator}->define_ruleset(
        '/blog.json/admin/post/new' =>
        { optional => 'id', valid => POS_VALUE },
        { optional => 'topics', valid => ANY_VALUE, split => ',' },
        { param    => 'raw_html', valid => POS_ZERO_VALUE },
        { param    => 'live', valid => POS_ZERO_VALUE },
        { param    => 'company_blog', valid => POS_ZERO_VALUE },
        { param    => 'users_id', valid => POS_VALUE },
        { param    => 'title', valid => ANY_VALUE },
        { param    => 'uri', valid => ANY_VALUE },
        { param    => 'teaser', valid => ANY_VALUE },
        { param    => 'content', valid => ANY_VALUE },
    );

};

register validate => sub {
    my ( $dsl, $ruleset, $ref ) = @_;
    my $app = $dsl->app;
    $app->{validator}->check_params( $ruleset, {}, $ref );
};

register_plugin;

1;
