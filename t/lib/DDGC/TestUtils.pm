package t::lib::DDGC::TestUtils;
use strict;
use warnings;

use DDGC::Base::Web::Common;
use Try::Tiny;

sub deploy {
    my ( $opts ) = @_;
    my $success = 1;
    try {
        if ($ENV{DDGC_DB_DSN} =~ /^dbi:SQLite/) {
            DDGC::Schema->connect($ENV{DDGC_DB_DSN})->deploy({
                add_drop_table => $opts->{drop} || 0
            });
        }
    }
    catch {
        $success = 0;
    };
    return $success;
}

# Create user, return user_id

post '/new_user' => sub {
    my $params = params('body');
    if (!$params->{username}) {
        send_error "'username' parameter not supplied", 400;
    }
    if (rset('User')->find({ username => $params->{username} })) {
        send_error( (sprintf "User %s exists", $params->{username}), 403);
    }

    my $error;
    my $user;
    try {
        $user = rset('User')->create({
            username => $params->{username},
        });
    }
    catch {
        $error = $_;
    };

    if (!$user || $error) {
        send_error "Something went wrong: $error", 500;
    }
    $user->add_role( $params->{role} ) if ($params->{role});
    return $user->id;
};

# Adds user to session, returns session id.

post '/user_session' => sub {
    my $params = params;
    if (!$params->{username}) {
        send_error "'username' parameter not supplied", 400;
    }
    if (my $user = rset('User')->find({ username => $params->{username} })) {
        session __user => $user->username;
    }
    else {
        send_error "'username' not found", 403;
    }
    return request->env->{'psgix.session.options'}->{id};
};

get '/debug_session' => sub {
    use DDP; p session; p request->env;
    return 1;
};

1;
