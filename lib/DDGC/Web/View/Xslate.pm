package DDGC::Web::View::Xslate;

use Moose;
extends 'Catalyst::View::Xslate';

use DDGC::Web;
use Text::Xslate qw( mark_raw );

__PACKAGE__->config(
	path => [
		DDGC::Web->path_to('templates_xslate'),
	],
	function => {
		r => sub { mark_raw(join"",@_) },
        results => sub { [ shift->all ] },
	},
	expose_methods => [qw(
		next_template
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

sub u {
    my $self = shift;
	my $c = shift;
	$c->chained_uri(@_);
}

sub l {
    my $self = shift;
	my $c = shift;
	$c->localize(@_);
}

1;
