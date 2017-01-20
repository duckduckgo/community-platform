package DDGC::Web::Service::Bounce;

# ABSTRACT: Bounce management

use DDGC::Base::Web::LightService;
use JSON::MaybeXS;
use HTTP::Tiny;

my $json = JSON::MaybeXS->new;

sub verify_subscription {
    my $ok = 1;
    my $res = HTTP::Tiny->new->get( $_[0]->{SubscribeURL} );
    if ( !$res->{success} ) {
        status $res->{status};
        $ok = 0;
    }
    return {
        ok => $ok,
        status => $res->{status},
        message => $res->{reason}
    };
}

post '/handler' => sub {
    my $packet = params('body');

    if ( $packet->{Type} eq 'SubscriptionConfirmation' ) {
        return verify_subscription( $packet );
    }
    my $message = decode_json( $packet->{Message} );
    rset('User')->handle_bounces( $message );
    return rset('Subscriber')->handle_bounces( $message );
};

1;
