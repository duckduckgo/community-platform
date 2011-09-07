use strict;
use warnings;

use DDGC::Web;

my $app = DDGC::Web->apply_default_middlewares(DDGC::Web->psgi_app);
$app;

