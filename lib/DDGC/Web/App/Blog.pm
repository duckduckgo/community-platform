package DDGC::Web::App::Blog;

use DDGC::Base::Web::App;

get '/' => sub {
    my $page = param_hmv('page') || 1;
    my $p = ddgcr_get( [ 'Blog' ], { page => $page } );

    if ( $p->is_success ) {
        template 'blog/index', { $p->{ddgcr} };
    }
    else {
        status 404;
    }
};

get '/page/:page' => sub {
    forward '/', { params('route') };
}

1;
