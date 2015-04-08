package DDGC::Web::Service::UserLoggedIn;

use Dancer2;
use Dancer2::Plugin::DBIC;
use DDGC::Config;

my $config = DDGC::Config->new;

set plugins => {
    DBIC => {
        default => {
            dsn         => $config->db_dsn,
            user        => $config->db_user,
            password    => $config->db_password,
        }
    },
};

set serializer => 'JSON';

set session => 'PSGI';

get '/' => sub {
    schema->resultset('User')->find(
        { username => session('__user') },
        { result_class => 'DBIx::Class::ResultClass::HashRefInflator',
          columns => [ qw/ id username /],
        }
    );
};

1;
