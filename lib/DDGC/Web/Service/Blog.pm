package DDGC::Web::Service::Blog;

# ABSTRACT: Blog post management JSON service

=pod

=head1 NAME

DDGC::Web::Service::Blog - blog post retrieval and update services

=head1 DESCRIPTION

This module provides an interface to retrieve pages of posts and single posts via
new and legacy URIs.

It also allows admins to update posts and create new posts.

=head1 MOUNT POINT

This service is expected to be mounted on '/blog.json'

=head1 REQUEST HANDLERS

=cut

use DDGC::Base::Web::Service;
use Try::Tiny;
use POSIX;

sub pagesize { 20 }

sub posts_rset {
    rset('User::Blog')->company_blog;
}

sub text_to_slug {
    my ( $title ) = @_;
    $title = lc( $title );
    $title =~ s/[^a-z]+/-/g;
    return $title;
}

sub posts_page {
    my ( $params ) = @_;
    $params = validate('/blog.json', $params)->values;

    my $posts_rset = posts_rset->search_rs({}, {
        order_by => { -desc => \'coalesce( me.fixed_date, me.created )' },
        rows     => $params->{pagesize} || pagesize,
        page     => $params->{page} || 1,
    });

    return $posts_rset->filter_by_topic( $params->{topic} )
        if ( $params->{topic} );
    return $posts_rset;
}

sub total {
    my ( $topic ) = @_;
    return posts_rset->filter_by_topic( $topic )->count if ( $topic );
    return posts_rset->count;
}

sub topics {
    [ posts_rset->topics ];
}

=head2 GET '/post/by_url'

Support for legacy links where url was the primary identifier.

=head3 Request Parameters

B<url> - Post url field.

=head3 Returns

JSON - A single blog post

=head3 Alternatives:

B<GET '/post/by_url/[url]'>

=cut

get '/post/by_url' => sub {
    if (
        param_hmv('url') &&
        (my $post = posts_rset->search(
            { uri => param_hmv('url') },
            { order_by => { -asc => 'me.id' } }
        )->prefetch([qw/ user comments /])->first)
    ) {
        return {
            post     => $post,
            comments => $post->comments->prefetch('user')->threaded,
            topics   => topics,
        };
    }
    bailout( 404, "Not found" );
};

get '/post/by_url/:url' => sub {
    forward '/post/by_url', { params('route') };
};

=head2 GET '/'

Retrieve a page of blog posts.

=head3 Request Parameters

B<page> - The page of posts to return. Default is 1.

B<pagesize> - Number of posts per-page. Default is 20. Max is 20.

B<topic> - String, a single topic.

=head3 Returns

JSON - A page of rendered blog posts.

=head3 Alternatives:

B<GET '/page/[page]'>

B<GET '/page/[page]/pagesize/[pagesize]'>

=cut

get '/' => sub {
    +{
        posts => [
            posts_page(params_hmv)
                ->prefetch([qw/ user comments /])
                ->all
            ],
        page  => param_hmv('page') // 1,
        pages => ceil(
            total( param_hmv('topic') ) /
              ( param_hmv('pagesize') || pagesize() )
        ),
        topics => topics(),
    };
};

get '/page/:page' => sub {
    forward '/', { params('route') };
};

get '/page/:page/pagesize/:pagesize' => sub {
    forward '/', { params('route') };
};

=head2 GET '/by_user'

Retrieve posts authored by a given user.

=head3 Request Parameters

B<id> - User ID.

=head3 Returns

JSON - Blog posts authored by a given user

=head3 Alternatives:

B<GET '/by_user/[id]'>

=cut

get '/by_user' => sub {
    if ( param_hmv('id') ) {
        my $posts = posts_rset->search(
            { users_id => param_hmv('id') },
            { order_by => { -desc => 'id' } }
        );
        return {
            posts  => $posts,
            topics => topics,
        } if ($posts->first);
    }
    bailout( 404, "Not found" );
};

get '/by_user/:id' => sub {
    forward '/by_user', { params('route') };
};

=head2 GET '/post'

Retrieve a single blog post.

=head3 Request Parameters

B<id> - Post ID.

=head3 Returns

JSON - A single blog post

=head3 Alternatives:

B<GET '/post/by_id/[id]'>

B<GET '/post/[id]'>

=cut

get '/post' => sub {
    my $v = validate('/blog.json/post', params_hmv );
    if (
        !(scalar $v->errors) &&
        (my $post = rset('User::Blog')
            ->prefetch([
                'user',
                { comments => 'user' },
            ])
            ->order_by(
                { -desc => 'comments.id' }
            )
            ->find(
                $v->values->{id}
            )
        )
    ) {
        return {
            post     => $post,
            comments => $post->comments->prefetch('user')->threaded,
            topics   => topics,
        };
    }
    bailout( 404, "Not found" );
};

get '/post/:id' => sub {
    forward '/post', { params('route') };
};

get '/post/by_id/:id' => sub {
    forward '/post', { params('route') };
};

=head2 GET '/admin/post/raw'

Retrieve an "un-rendered" post for editing.

=head3 Required Role

Admin.

=head3 Request Parameters

B<id> - Post ID.

=head3 Returns

JSON - A single blog post, suitable for editing in a form.

=head3 Alternatives:

B<GET '/admin/post/raw/[id]'>

=cut

get '/admin/post/raw' => user_is 'admin' => sub {
    my $v = validate('/blog.json/post', params_hmv);
    if (scalar $v->errors) {
        bailout( 400, [ $v->errors ] );
    }
    if (my $post = rset('User::Blog')->find( $v->values->{id} )) {
        return { post => $post->for_edit };
    }
    bailout( 404, sprintf "Post %s not found", $v->values->{id} );
};

get '/admin/post/raw/:id' => sub {
    forward '/admin/post/raw', { params('route') };
};

sub post_update_or_create {
    my ( $params ) = @_;
    my $post;
    my $error;
    my $user = var 'user';
    $params->{users_id} = $user->id;
    $params->{uri} = ( $params->{uri} )
        ? text_to_slug( $params->{uri} )
        : text_to_slug( $params->{title} );

    my $v = validate('/blog.json/admin/post/new', $params);
    bailout( 400, [ $v->errors ] ) if (scalar $v->errors);
    $params = $v->values;

    if ( $params->{id} ) {
        $post = rset('User::Blog')->find( $params->{id} );
        bailout( 404, sprintf "Blog post %s not found", $params->{id} )
            if (!$post);

        bailout( 403, "You do not have permission to update this post" )
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

=head2 POST '/admin/post/update'

Update a blog post.

=head3 Required Role

Admin.

=head3 Body Parameters

Body content is JSON.

Fields:

B<id> - Post ID.

Also,

B<title> - Updated post title.

B<content> - Updated post content.

etc.

Remaining fields are defined in L<DDGC::Schema::User::Blog>.

=head3 Returns

JSON - The updated blog post content.

=cut

post '/admin/post/update' => user_is 'admin' => sub {
    post_update_or_create { params('body') };
};

=head2 POST '/admin/post/new'

Create a new blog post.

=head3 Required Role

Admin.

=head3 Body Parameters

Body content is JSON.

Fields:

B<title> - New post title.

B<content> - New post content.

etc.

Remaining fields are defined in L<DDGC::Schema::User::Blog>.

=head3 Returns

JSON - The new blog post content.

=cut

post '/admin/post/new' => user_is 'admin' => sub {
    post_update_or_create { params('body') };
};

1;
