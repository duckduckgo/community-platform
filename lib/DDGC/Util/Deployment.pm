use strict;
use warnings;
package DDGC::Util::Deployment;
# ABSTRACT: Useful common features of deployment / service scripts

use autodie;
use CHI;
use Plack::Session::State::Cookie;
use Plack::Session::Store::File;
use File::Path qw/ make_path /;

use Moo;

has tmp_dir => (
    is => 'ro',
    lazy => 1,
    builder => '_build_tmp_dir',
);
sub _build_tmp_dir {
    $ENV{TMPDIR} || $ENV{HOME}  . '/ddgc/tmp';
}

has session_dir => (
    is => 'ro',
    lazy => 1,
    builder => '_build_session_dir',
);
sub _build_session_dir {
    my $tmp = $_[0]->tmp_dir . '/sessions';
    if (!-d $tmp) {
        make_path( $tmp, { mode => 0700 } );
    }
    return $tmp;
}

has session_store => (
    is => 'ro',
    lazy => 1,
    builder => '_build_session_store',
);
sub _build_session_store {
    Plack::Session::Store::File->new(
        dir => $_[0]->session_dir,
    ),
}

has session_state => (
    is => 'ro',
    lazy => 1,
    builder => '_build_session_state',
);
sub _build_session_state {
    Plack::Session::State::Cookie->new(
        secure => 1,
        httponly => 1,
        expires => 21600,
        session_key => 'ddgc_session',
    );
}

1;
