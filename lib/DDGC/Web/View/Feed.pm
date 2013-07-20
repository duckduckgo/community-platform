package DDGC::Web::View::Feed;
# ABSTRACT: Standard Catalyst Feed view

use Moose;
extends qw( Catalyst::View::XML::Feed );

no Moose;
__PACKAGE__->meta->make_immutable;
