package DDGC::Web::App::UserLoggedIn;

use Dancer2;
use Dancer2::Plugin::DBIC;
use DDGC;
use DDGC::Web;

my $d = DDGC->new;
my $c = DDGC::Web->new;
my $config = $d->config;
my $xslate = $d->xslate;

set plugins => {
    DBIC => {
        default => {
            dsn         => $config->db_dsn,
            user        => $config->db_user,
            password    => $config->db_password,
        }
    },
};

set session => 'PSGI';

get '/' => sub {
    my $user = schema->resultset('User')->find({ username => session('__user') });
    return 'None' if !$user;
    my @templates = ( qw/base.tx loggedinuser.tx/ );
    $xslate->{functions}->{next_template} = sub {
        shift @templates;
    };
    $xslate->{functions}->{u} = sub {
        '/';
    };
    return $xslate->render(shift @templates, {
        user => $user,
        c => { d => $d, user => $user },
        next_template => sub { shift @templates; },
        u => sub { $c->chained_uri(map { (ref $_ eq 'ARRAY') ? @{$_} : $_ } @_) },
    });
};

1;
