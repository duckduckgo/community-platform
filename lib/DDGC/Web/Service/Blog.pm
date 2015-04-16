package DDGC::Web::Service::Blog;

use DDGC::Base::Web::Service;

sub pagesize { 20 }

sub posts_page {
    my ( $params ) = @_;
    $params = validate('/blog.json', $params)->values;

    rset('User::Blog')->company_blog->search_rs({}, {
        order_by => { -desc => 'id' },
        rows     => $params->{pagesize} || pagesize,
        page     => $params->{page} || 1,
    });
}

get '/' => sub {
    { posts => posts_page( params_hmv ) };
};

get '/page/:page' => sub {
    forward '/', { params('route') };
};

get '/page/:page/pagesize/:pagesize' => sub {
    forward '/', { params('route') };
};

1;
