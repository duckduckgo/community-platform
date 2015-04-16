package DDGC::Web::Service::Blog;

use DDGC::Base::Web::Service;

sub pagesize { 20 }

sub posts_page {
    my ( $page, $pagesize ) = @_;
    ($page) && ( $page = int( abs( $page + 0 ) ) );
    $page ||= 1;
    ($pagesize) && ( $pagesize = int( abs( $pagesize + 0 ) ) );
    $pagesize ||= pagesize;
    ($pagesize > pagesize) && ($pagesize = pagesize);

    rset('User::Blog')->company_blog->search_rs({}, {
        order_by => { -desc => 'id' },
        rows     => $pagesize,
        page     => $page,
    });
}

get '/' => sub {
    { posts => posts_page( param_hmv('page'), param_hmv('pagesize') ) };
};

get '/page/:page' => sub {
    { posts => posts_page( params('route')->{page} ) };
};

get '/page/:page/pagesize/:pagesize' => sub {
    { posts => posts_page( params('route')->{page}, params('route')->{pagesize} ) };
};

1;
