package DDGC::Web::Service::Blog;

use DDGC::Web::Service::Base;

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
