package t::lib::DDGC::TestUtils;
use strict;
use warnings;

use DDGC;
use DDGC::Base::Web::Common;
use Try::Tiny;

my $d = DDGC->new;

sub deploy {
    my ( $opts, $schema ) = @_;
    my $success = 1;
    try {
        if ($ENV{DDGC_DB_DSN} =~ /^dbi:SQLite/) {
            my $fn = $ENV{DDGC_DB_DSN} =~ s/.*dbname=(.*)/$1/r;
            unlink $fn if $fn;
            if ( $schema ) {
                $schema->deploy({
                    add_drop_table => $opts->{drop} || 0
                });
            }
            else {
                DDGC::Schema->connect($ENV{DDGC_DB_DSN})->deploy({
                    add_drop_table => $opts->{drop} || 0
                });
            }
        }
    }
    catch {
        $success = 0;
    };
    return $success;
}

sub ok {
    +{
        ok => 1,
        @_,
    }
}

sub not_ok {
    +{
        ok => 0,
        msg => shift,
        @_,
    }
}

sub new_user {
    my ( $username, $role ) = @_;
    return not_ok "'username' parameter not supplied" if !$username;
    return not_ok sprintf( "User %s exists", $username )
        if rset('User')->find_by_username( $username );

    my $error;
    my $user;
    try {
        $user = rset('User')->create({
            username => $username
        });
    }
    catch {
        $error = $_;
    };

    if (!$user || $error) {
        return not_ok sprintf( "Something went wrong: %s", $error );
    }
    $user->add_role( $role ) if $role;
    return ok ( user_id => $user->id, user => $user );
}

sub new_gh_user {
    my ( $username, $gh_id, $role ) = @_;
    return not_ok "'username' parameter not supplied" if !$username;
    return not_ok sprintf( "User %s exists", $username )
        if rset('User')->find_by_username( $username );

    my $error;
    my $user;
    try {
        $user = rset('User')->create({
            username => $username,
            github_id => $gh_id
        });
    }
    catch {
        $error = $_;
    };

    if ($gh_id) {
        return not_ok sprintf( "User %s exists", $username )
            if $d->rs('GitHub::User')->find({ login => $username });

        my $gh_error;
        my $gh_user;
        try {
            $gh_user = $d->rs('GitHub::User')->create({
                login => $username,
                github_id => $gh_id
            });
        }
        catch {
            $gh_error = $_;
        };
        
        if (!$gh_user || $gh_error) {
            return not_ok sprintf( "Something went wrong: %s", $gh_error );
        }
    }

    if (!$user || $error) {
        return not_ok sprintf( "Something went wrong: %s", $error );
    }
    $user->add_role( $role ) if $role;
    return ok ( user_id => $user->id, user => $user );
}

# Create user, return user_id

post '/new_user' => sub {
    my $params = params('body');
    my $result = $params->{github_id}? new_gh_user( $params->{username}, $params->{github_id}, $params->{role} ) : new_user($params->{username}, $params->{role});
    return $result->{user_id} if $result->{ok};
    send_error $result->{msg}, 500;
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

get '/action_token' => sub {
    return session('action_token');
};

1;
