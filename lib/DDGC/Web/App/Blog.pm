package DDGC::Web::App::Blog;

# ABSTRACT: Rendering service application for blog posts and RSS

use DDGC::Base::Web::App;
use Dancer2::Plugin::Feed;
use Scalar::Util qw/ looks_like_number /;

sub title { 'DuckDuckGo Blog' };

sub feed {
    my ( $posts ) = @_;
    create_feed(
        format  => 'Atom',
        title   => title,
        entries => [
            map {{
                id          => $_->{id},
                link        => uri_for($_->{path}),
                title       => $_->{title},
                modified    => $_->{updated},
                content     => $_->{content},
                author      => $_->{user}->{username},
            }} @{ $posts }
        ],
    );
}

# This intercepts all routes to set a body class.
# TODO: Get a better way to do this.
get qr/^.*/ => sub {
    var( page_class => 'page-blog texture' );
    var( include_atom_link_rel => 1 );
    pass;
};

get '/' => sub {
    my $page = param_hmv('page') || 1;
    my $rs = rset('User::Blog')->single_page_ref( $page, param_hmv('topic') );

    if ( scalar @{ $rs->{ posts } } ) {
        return template 'blog/index', {
            %{ $rs },
            title => title,
            topic => param_hmv('topic'),
        };
    }
    else {
        status 404;
    }
};

get '/page/:page' => sub {
    forward '/', { params('route') };
};

get '/rss' => sub {
    my $p = rset('User::Blog')->single_page_ref;
    return feed( $p->{posts} );
};

get '/topic/:topic/rss' => sub {
    my $p = rset('User::Blog')->single_page_ref( 1, params('route')->{topic} );
    return feed( $p->{posts} );
};

get '/topic/:topic' => sub {
    forward '/', {
        topic => params('route')->{topic},
        page  => param_hmv('page') || 1,
        url   => ''
    };
};

get '/post/:id/:uri' => sub {
    my $params = params('route');
    # Since we have a login prompt on this page, set last_url
    # TODO: Make this happen for everything (in login handler?)
    session last_url => request->env->{REQUEST_URI};
    my $post = rset('User::Blog')->single_post_ref( $params->{id} );
    if ( $post->{post} ) {
        if ( $post->{post}->{uri} ne $params->{uri} ) {
            redirect '/post/' . $post->{post}->{id} . '/' . $post->{post}->{uri};
        }
        template 'blog/index', {
            %{ $post },
            title => join ' : ', ( title, $post->{post}->{title} ),
        };
    }
    else {
        status 404;
    }
};

get '/:uri_or_id' => sub {
    my $uri_or_id = params('route')->{uri_or_id};
    my $post = ( looks_like_number( $uri_or_id ) )
        ? rset('User::Blog')->company_blog->find( int( $uri_or_id + 0 ) )
        : rset('User::Blog')->company_blog
                            ->search( { uri => $uri_or_id } )
                            ->one_row;
    if ( $post ) {

        my ($id, $uri) = (
            $post->id,
            $post->uri,
        );

        redirect "/post/$id/$uri";
    };
    status 404;
};

1;
