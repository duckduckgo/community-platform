package DDGC::Web::Service::ActivityFeed;

# ABSTRACT: Community Activity JSON service

=pod

=head1 NAME

DDGC::Web::Service::ActivityFeed - Log / retrieve Community Activity.

=head1 DESCRIPTION

This service logs any activity you care to generate and allows subscription
to these activities via a key of your choosing.

=head1 MOUNT POINT

This service is expected to be mounted on '/activityfeed.json'

=head1 REQUEST HANDLERS

=cut

use DDGC::Base::Web::Service;
use Try::Tiny;

sub pagesize { 40 }

sub activity_page {
    my ( $params ) = @_;
    $params->{page} //= 1;
    $params->{pagesize} //= pagesize;
    rset('ActivityFeed')->search_rs({
        ( $params->{filter} )
            ? ( type => { -like => $params->{filter} =~ s/\*/%/gr } )
            : (),
    }, {
        order_by => { -desc => 'me.id' },
        rows     => $params->{pagesize},
        page     => $params->{page},
    });
}

get '/' => sub {
    +{
        activity => [
            activity_page(params_hmv)->all,
        ]
    };
};

post '/new' => sub {
    my $params = params_hmv;
    if ($params->{secret} ne config->{ddgc_config}->shared_secret) {
        bailout( 401, 'Unauthorized request' );
    }
    my $error = 0;
    my $result;

    try {
        $result = rset('ActivityFeed')->create({
            type => $params->{type},
            description => $params->{description},
            ( $params->{format} )
                ? { format => $params->{format} }
                : (),
        });
    } catch {
        $error = 1;
    };

    bailout( 500, "Something went wrong" ) if ( $error );

    use DDP; p $result;
    return { ok => 1, result => $result };
};

1;
