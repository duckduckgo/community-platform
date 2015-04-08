package DDGC::Web::App::Blog;

use Dancer2;
use Dancer2::Plugin::DBIC;
use DDGC::Web::Plugin::Config;
use DDGC::Web::Plugin::Session;

get '/' => sub {
    request->var( templates => ['blog'] );
    template('base', request->vars);
};

1;
