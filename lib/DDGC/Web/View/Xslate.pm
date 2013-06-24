package DDGC::Web::View::Xslate;
# ABSTRACT: 

use Moose;
extends 'Catalyst::View::Xslate';

use DDGC::Util::DateTime ();
use Text::Xslate qw( mark_raw );

#
# WARNING: Configuration of Text::Xslate itself happens in DDGC->xslate
#
#########################################################################

__PACKAGE__->config(
	encode_body => 0,
	expose_methods => [qw(
		next_template
		link
		u
		l
		dur
		dur_precise
	)],
);

sub ddgc { shift->_app->d }

sub _build_xslate {
	my ( $self ) = @_;
	$self->ddgc->xslate; # using central xslate system
}

sub process {
    my $self = shift;
	my $c = shift;
	$c->stash->{template_layout} ||= [];
	my @layouts = ( @{$c->stash->{template_layout}}, $c->stash->{template} );
	$c->stash->{LAYOUTS} = \@layouts;
	$c->stash->{template} = shift @layouts;
    return $self->next::method($c,@_);
}

sub next_template {
	my ( $self, $c ) = @_;
	my @layouts = @{$c->stash->{LAYOUTS}};
	my $return = shift @layouts;
	$c->stash->{LAYOUTS} = \@layouts;
	return $return;
}

sub link {
	my ( $self, $c, $object, @args ) = @_;
	return $c->chained_uri($object->u,@args);
}

# url
sub u { shift; shift->chained_uri(@_) }

# localize
sub l { shift; shift->localize(@_) }

# legacy, use dur() in template not $dur()
sub dur { my ( $self, $c, $date ) = @_; DDGC::Util::DateTime::dur($date); }
sub dur_precise { my ( $self, $c, $date ) = @_; DDGC::Util::DateTime::dur_precise($date); }

1;
