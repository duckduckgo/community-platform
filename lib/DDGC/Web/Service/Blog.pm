package DDGC::Web::Service::Blog;

use DDGC::Base::Web::Service;

sub pagesize { 20 }

get '/' => sub {
    my $posts = rset('User::Blog')->company_blog->search({}, {
        page => param('page') || 1,
        rows => pagesize,
    });
    { posts => $posts };
};

1;
