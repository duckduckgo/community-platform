package DDGC::Web::App::Blog;

use DDGC::Base::Web::App;
use Dancer2::Plugin::Feed;
use Scalar::Util qw/ looks_like_number /;

get '/' => sub {
    my $page = param_hmv('page') || 1;
    my $res = ddgcr_get( [ 'Blog' ], { page => $page } );

    if ( $res->is_success ) {
        template 'blog/index', { $res->{ddgcr} };
    }
    else {
        status 404;
    }
};

get '/page/:page' => sub {
    forward '/', { params('route') };
};

get '/rss' =>sub {
    my $p = ddgcr_get( [ 'Blog' ], { page => 1 } );
    use DDP; p( schema->storage ); p( $p );
    if ( $p->is_success ) {
        return create_feed(
            format => 'Atom',
            title  => 'DuckDuckGo Blog',
            entries => [
                map {{
                    id          => $_->{id},
                    link        => uri_for($_->{uri}),
                    title       => $_->{title},
                    modified    => $_->{updated},
                    content     => $_->{content},
                }} @{ $p->{ddgcr}->{posts} }
            ],
        );
    }
    status 404;
};

get '/:id/:uri' => sub {
    my $params = params('route');
    my $post;
    my $res = ddgcr_get [ 'Blog', 'post' ], { id => $params->{id} };
    if ( $res->is_success ) {
        $post = $res->{ddgcr}->{post};

        if ( $post->{uri} ne $params->{uri} ) {
            redirect '/' . $post->{id} . '/' . $post->{uri};
        }

        template 'blog/index', { $res->{ddgcr} };
    }
    else {
        status 404;
    }
};

get '/:uri_or_id' => sub {
    my $uri_or_id = params('route')->{uri_or_id};
    my $req = ( looks_like_number( $uri_or_id ) )
        ? ddgcr_get [ 'Blog', 'post' ], { id => int( $uri_or_id + 0 ) }
        : ddgcr_get [ 'Blog', 'post', 'by_url' ], { url => $uri_or_id };
    if ( $req->is_success ) {

        my ($id, $uri) = (
            $req->{ddgcr}->{post}->{id},
            $req->{ddgcr}->{post}->{uri},
        );

        redirect "/$id/$uri";
    };
    status 404;
};

1;
