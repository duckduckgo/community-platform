package DDGC::Web::App::Subscriber;

# ABSTRACT: Subscriber management

use DDGC::Base::Web::Light;

get '/u/:campaign/:email/:key' => sub {
    my $params = params('route');
    my $s = rset('Subscriber')->find( {
        email_address => $params->{email},
        campaign      => $params->{campaign},
    } );
    if ( !$s || !$s->unsubscribe( $params->{ key } ) ) {
        status 500;
        return "NOT OK";
    }
    return "OK";
};

get '/v/:campaign/:email/:key' => sub {
    my $params = params('route');
    my $s = rset('Subscriber')->find( {
        email_address => $params->{email},
        campaign      => $params->{campaign},
    } );
    if ( !$s || !$s->verify( $params->{ key } ) ) {
        status 500;
        return "NOT OK";
    }
    return "OK";
};

get '/form' => sub {
    return <<'FORM'
    <form method="POST" action="/s/a">
        email: <input type="text" name="email">
        <input type="submit" name="submit">
        <input type="hidden" name="campaign" value="a">
        <input type="hidden" name="flow" value="form">
    </form>
FORM
};

post '/a' => sub {
    my $params = params('body');
    my $s = rset('Subscriber')->create( {
        email_address => $params->{email},
        campaign      => $params->{campaign},
        flow          => $params->{flow}
    } );
    if ( !$s ) {
        status 500;
        return "NOT OK";
    }
    return "OK";
};

1;
