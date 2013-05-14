package DDGC::Web::View::Xslate;

use Moose;
extends 'Catalyst::View::Xslate';

use DDGC::Web;
use Text::Xslate qw( mark_raw );

__PACKAGE__->config(
	path => [
		DDGC::Web->path_to('templates_xslate'),
	],
	encode_body => 0,
	function => {
		r => sub { mark_raw(join"",@_) },
		results => sub { [ shift->all ] },
		call => sub {
			my $thing = shift;
			my $func = shift;
			$thing->$func;
		},
		call_if => sub {
			my $thing = shift;
			my $func = shift;
			$thing->$func if $thing;
		},
		replace => sub {
			my $source = shift;
			my $from = shift;
			my $to = shift;
			$source =~ s/$from/$to/g;
			return $source;
		},
	},
	expose_methods => [qw(
		next_template
		link
		u
		l
	)],
);

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

sub u { shift; shift->chained_uri(@_) }

sub l { shift; shift->localize(@_) }

1;
