package Dancer2::Plugin::DDGC::Validate;

# ABSTRACT: HTTP::Validate wrapper with pre-defined rulesets

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
        { optional => 'topic', valid => ANY_VALUE },
    );
    $app->{validator}->define_ruleset(
        '/blog.json/post' =>
        { param => 'id', valid => POS_VALUE },
    );
    $app->{validator}->define_ruleset(
        '/blog.json/admin/post/new' =>
        { optional => 'id', valid => POS_VALUE },
        { optional => 'topics', valid => ANY_VALUE, split => ',' },
        { optional => 'fixed_date', valid => ANY_VALUE },
        { param    => 'company_blog', valid => POS_ZERO_VALUE },
        { param    => 'format', valid => ENUM_VALUE(qw/ html markdown bbcode /) },
        { param    => 'live', valid => POS_ZERO_VALUE },
        { param    => 'users_id', valid => POS_VALUE },
        { param    => 'uri', valid => ANY_VALUE },
        { mandatory => 'teaser', valid => ANY_VALUE },
        { mandatory => 'content', valid => ANY_VALUE },
        { mandatory => 'title', valid => ANY_VALUE },
    );

};

register validate => sub {
    my ( $dsl, $ruleset, $ref ) = @_;
    my $app = $dsl->app;
    $app->{validator}->check_params( $ruleset, {}, $ref );
};

register_plugin;

1;

__END__

=pod

=head1 NAME

Dancer2::Plugin::DDGC::Validate - HTTP::Validate wrapper with pre-defined rulesets

=head1 SYNOPSIS

    use Dancer2;
    use Dancer2::Plugin::DDGC::Validate;

    get '/post' => sub {
        my $v = validate( '/blog.json', params );
        if ( scalar $v->errors ) {
            # handle errors, $v->errors is array of error messages
        }
        my $params = $v->values;
    }

=head1 DESCRIPTION

Dancer2::Plugin::DDGC::Validate provides parameter validation via L<HTTP::Validate>.

Rule sets are defined within this module, then called from request handlers.
If you want new rule sets, add them to C<on_plugin_import> in this module.

=head1 FUNCTIONS

=head2 validate

Expects the ruleset name and params hashref as arguments. Returns a
L<HTTP::Validate::Result> instance.

This instance can be checked for errors with the C<errors> accessor and filtered
values are available in the C<values> accessor.

    my $v = validate( '/blog.json/admin/post/new', params );
    if ( scalar $v->errors ) {
        bailout 400, [ $v->errors ]
    }
    rset('Blog')->create( $v->values )

=cut
