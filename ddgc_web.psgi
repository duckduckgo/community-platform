use strict;
use warnings;

use DDGC::Web;
use Plack::Builder;

my $app = DDGC::Web->apply_default_middlewares(DDGC::Web->psgi_app);

builder {
	enable 'Debug', panels => [ qw(CatalystLog DBITrace Memory Timer Parameters Session Response) ] if DDGC::Web->debug;
	$app;
};
