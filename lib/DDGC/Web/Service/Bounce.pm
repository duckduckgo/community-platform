package DDGC::Web::Service::Bounce;

# ABSTRACT: Bounce management

use DDGC::Base::Web::LightService;
use JSON::MaybeXS;

my $json = JSON::MaybeXS->new;

sub verify {
    my $res = HTTP::Tiny->new->get( $_[0]->{SubscribeURL} );
    status $res->{status} unless $res->{success};
    return { content => $res->{content} };
}

post '/handler' => sub {
    my $packet = params('body');

    if ( $packet->{Type} eq 'SubscriptionConfirmation' ) {
        return verify( $packet );
    }
    return rset('Subscriber')->handle_bounces( decode_json( $packet->{Message} ) );
};

1;
