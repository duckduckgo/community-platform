package DDGC::Web::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

use DDGC::Config;

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

sub base :Chained('/') :PathPart('') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	$c->stash->{template_layout} = [ 'base.tt' ];
	$c->stash->{u} = sub { $c->chained_uri(@_) };
	$c->stash->{l} = sub { $c->localize(@_) };
	$c->stash->{xmpp_userhost} = DDGC::Config::prosody_userhost;
}

sub index :Chained('base') :PathPart('') :Args(0) {}

sub default :Chained('base') :PathPart('') :Args {
    my ( $self, $c ) = @_;
    $c->response->status(404);
}

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;
	my $template = $c->action.".tt";
	push @{$c->stash->{template_layout}}, $template;
}

=head1 AUTHOR

Torsten Raudssus

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
