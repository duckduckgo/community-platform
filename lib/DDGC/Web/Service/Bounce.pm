package DDGC::Web::Service::Bounce;

# ABSTRACT: Bounce management

use DDGC::Base::Web::LightService;
use JSON::MaybeXS;
use HTTP::Tiny;
use Try::Tiny;
use AWS::SNS::Verify;

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

sub verify_message {
    my ( $body ) = @_;
    return 1 if !config->{verify_sns};
    try {
        AWS::SNS::Verify->new( body => $body )->verify;
        return 1;
    } catch {
        return 0;
    };
}

post '/handler' => sub {
    my $packet = params('body');
    return { ok => 0, status => 401 }
        if (!verify_message( request->body ) );

    if ( $packet->{Type} eq 'SubscriptionConfirmation' ) {
        return verify_subscription( $packet );
    }
    my $message = decode_json( $packet->{Message} );
    rset('User')->handle_bounces( $message );
    return rset('Subscriber')->handle_bounces( $message );
};

1;
