package DDGC::Web::App::Blog;

use DDGC::Web::App::Base;

get '/' => sub {
    request->var( templates => ['blog'] );
    template('base', request->vars);
};

1;
