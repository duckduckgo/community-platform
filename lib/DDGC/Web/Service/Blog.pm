package DDGC::Web::Service::Blog;

use DDGC::Base::Web::Service;
use POSIX;

sub pagesize { 20 }

sub posts_rset {
    rset('User::Blog')->company_blog;
}

sub posts_page {
    my ( $params ) = @_;
    $params = validate('/blog.json', $params)->values;

    posts_rset->search_rs({}, {
        order_by => { -desc => 'id' },
        rows     => $params->{pagesize} || pagesize,
        page     => $params->{page} || 1,
    })->all;
}

sub total {
    posts_rset->count;
}

get '/' => sub {
    [ posts_page( params_hmv ) ];
};

get '/page/:page' => sub {
    forward '/', { params('route') };
};

get '/page/:page/pagesize/:pagesize' => sub {
    forward '/', { params('route') };
};

get '/total' => sub {
    total;
};

get '/numpages' => sub {
    ceil( total() / ( param_hmv('pagesize') || pagesize ) );
};

get '/numpages/:pagesize?' => sub {
    forward '/numpages', { params('route') };
};

get '/numpages/pagesize/:pagesize' => sub {
    forward '/numpages', { params('route') };
};

1;
