package DDGC::Web::Service::Blog;

use Dancer2;
use Dancer2::Plugin::DBIC;
use DDGC::Web::Plugin::Config;
use DDGC::Web::Plugin::Session;
use DDGC::Web::Plugin::Service;

sub pagesize { 20 }

get '/' => sub {
    schema->resultset('User')->find(
        { username => session('__user') },
        { result_class => 'DBIx::Class::ResultClass::HashRefInflator',
          columns => [ qw/ id username /],
        }
    );
};

1;
