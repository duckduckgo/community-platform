package DDGC::Web::App::Subscriber;

# ABSTRACT: Subscriber management

use DDGC::Base::Web::Light;
use Email::Valid;

get '/u/:campaign/:email/:key' => sub {
    my $params = params('route');
    my $s = rset('Subscriber')->find( {
        email_address => $params->{email},
        campaign      => $params->{campaign},
    } );
    template 'email/a/unsub.tx',
             { success => (
                     $s && $s->unsubscribe( $params->{ key } )
                 )
             },
             { layout => undef };
};

get '/v/:campaign/:email/:key' => sub {
    my $params = params('route');
    my $s = rset('Subscriber')->find( {
        email_address => $params->{email},
        campaign      => $params->{campaign},
    } );
    template 'email/a/verify.tx',
             { success => (
                     $s && $s->verify( $params->{ key } )
                 )
             },
             { layout => undef };
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
    my $email = Email::Valid->address($params->{email});
    return unless $email;
    my $s = rset('Subscriber')->create( {
        email_address => $email,
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
