package DDGC::Web::Service::Blog;

use DDGC::Base::Web::Service;
use Try::Tiny;
use POSIX;

sub pagesize { 20 }

sub posts_rset {
    rset('User::Blog')->for_user( var 'user' )->company_blog->search_rs({},
        { cache_for => 300 }
    );
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
    { posts => [ posts_page( params_hmv ) ] };
};

get '/page/:page' => sub {
    forward '/', { params('route') };
};

get '/page/:page/pagesize/:pagesize' => sub {
    forward '/', { params('route') };
};

get '/by_user' => sub {
    if ( param_hmv('id') ) {
        my $posts = posts_rset->search(
            { users_id => param_hmv('id') },
            { order_by => { -desc => 'id' } }
        );
        return { posts => $posts } if ($posts->first);
    }
    return bailout( 404, "Not found" );
};

get '/by_user/:id' => sub {
    forward '/by_user', { params('route') };
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

get '/post' => sub {
    my $v = validate('/blog.json/post', params_hmv );
    if (
        !(scalar $v->errors) &&
        (my $post = posts_rset->find( $v->values->{id} ))
    ) {
        return { post => $post };
    }
    return bailout( 404, "Not found" );
};

get '/post/:id' => sub {
    forward '/post', { params('route') };
};

get '/post/by_id/:id' => sub {
    forward '/post', { params('route') };
};

get '/post/by_url' => sub {
    if (
        param_hmv('url') &&
        (my $post = posts_rset->search(
            { url => param_hmv('url') },
            { order_by => { -asc => 'id' } }
        )->first)
    ) {
        return { post => $post };
    }
    return bailout( 404, "Not found" );
};

get '/post/by_url/:url' => sub {
    forward '/post/by_url', { params('route') };
};

get '/admin/post/raw' => user_is 'admin' => sub {
    my $v = validate('/blog.json/post', params_hmv);
    if (scalar $v->errors) {
        return bailout( 400, [ $v->errors ] );
    }
    if (my $post = rset('User::Blog')->find( $v->values->{id} ))
    {
        return { post => $post->for_edit };
    }
    return bailout( 404, sprintf "Post %s not found", $v->values->{id} );
};

get '/admin/post/:id' => sub {
    forward '/admin/post/raw', { params('route') };
};

sub post_update_or_create {
    my ( $params ) = @_;
    my $post;
    my $error;
    my $user = var 'user';
    $params->{users_id} = $user->id;

    my $v = validate('/blog.json/admin/post/new', $params);
    return bailout( 400, [ $v->errors ] ) if (scalar $v->errors);
    $params = $v->values;

    if ( $params->{id} ) {
        $post = rset('User::Blog')->find( $params->{id} );
        return bailout( 404, sprintf "Blog post %s not found", $params->{id} )
            if (!$post);

        return bailout( 403, "You do not have permission to update this post" )
            if ($post->users_id != $params->{users_id});
    }

    try {
        $post = rset('User::Blog')->update_or_create( $params );
    } catch {
        $error = $_;
    };

    bailout( 500, "DBIC Error: $error" ) if ($error || !$post);

    forward '/admin/post/raw', { id => $post->id }, { method => 'GET' };
}

post '/admin/post/update' => user_is 'admin' => sub {
    post_update_or_create { params('body') };
};

post '/admin/post/new' => user_is 'admin' => sub {
    post_update_or_create { params('body') };
};

1;
