package DDGC::Web::View::Xslate;

use Moose;
extends 'Catalyst::View::Xslate';

use DDGC::Web;
use Text::Xslate qw( mark_raw );

use DateTime;
use DateTime::Format::Human::Duration;

__PACKAGE__->config(
	path => [
		DDGC::Web->path_to('templates'),
	],
	encode_body => 0,
	function => {
		r => sub { mark_raw(join("",@_)) },
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
		urify => sub { lc(join('-',split(/\s+/,join(' ',@_)))) },
		# user page field view template
		upf_view => sub { 'userpage/'.$_[1].'/'.$_[0]->view.'.tx' },
		# user page field edit template
		upf_edit => sub { 'my/userpage/field/'.$_[0]->edit.'.tx' },
	},
	expose_methods => [qw(
		next_template
		link
		u
		l
		dur
		dur_precise
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
