package DDGC::Web::App::Blog;

use DDGC::Base::Web::App;

get '/' => sub {
    request->var( templates => ['blog'] );
    template('base', request->vars);
};

1;
