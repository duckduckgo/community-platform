package DDGC::Web::Service::Blog;

use Dancer2;
use Dancer2::Plugin::DBIC;
use DDGC::Web::Plugin::Config;
use DDGC::Web::Plugin::Session;
use DDGC::Web::Plugin::Service;

sub pagesize { 20 }

get '/' => sub {
    my $page = param('page') || 1;
    my @posts = schema('default')->resultset('User::Blog')->company_blog->search({},
    {
        page => $page,
        rows => pagesize,
    })->all;

    return map { +{
        title   => $_->title,
        uri     => $_->uri,
        content => $_->html,
        teaser  => $_->teaser,
        user    => $_->users_id,
        topics  => $_->topics,
        date    => $_->fixed_date || $_->created,
        }
    } @posts;

};

1;
