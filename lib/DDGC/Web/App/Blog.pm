package DDGC::Web::App::Blog;

use Dancer2;
use Dancer2::Plugin::DBIC;
use DDGC::Web::Plugin::Config;
use DDGC::Web::Plugin::Session;

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
