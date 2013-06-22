package DDGC::Web::View::Xslate;
# ABSTRACT: 

use Moose;
extends 'Catalyst::View::Xslate';

use DDGC::Web;
use Text::Xslate qw( mark_raw );

use DateTime;
use DateTime::Format::Human::Duration;

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

sub _build_xslate {
	my ( $self ) = @_;
	$self->_app->ddgc->xslate; # using central xslate system
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

sub dur {
	my ( $self, $c, $date ) = @_;
	$date = DateTime->from_epoch( epoch => $date ) unless ref $date;
	return DateTime::Format::Human::Duration->new->format_duration(
		DateTime->now - $date,
		'units' => [qw/years months days/],
		'past' => '%s ago',
		'future' => 'in %s will be',
		'no_time' => 'today',
	);
}

sub dur_precise {
	my ( $self, $c, $date ) = @_;
	$date = DateTime->from_epoch( epoch => $date ) unless ref $date;
	return DateTime::Format::Human::Duration->new->format_duration(
		DateTime->now - $date,
		'units' => [qw/years months days hours minutes/],
		'past' => '%s ago',
		'future' => 'in %s will be',
		'no_time' => 'today',
	);
}

1;
