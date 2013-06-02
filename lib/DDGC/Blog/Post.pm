package DDGC::Blog::Post;

use Moose;
use Moose::Util::TypeConstraints;
use DateTime;
use DateTime::Format::Flexible;
use IO::All;
use HTML::Restrict;

has uri => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has title => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has description => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has author => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

has topics => (
	is => 'ro',
	isa => 'ArrayRef[Str]',
	required => 1,
);

class_type 'DateTime';

coerce 'DateTime',
	from 'Str',
	via { DateTime::Format::Flexible->parse_datetime($_) };

has date => (
	is => 'ro',
	isa => 'DateTime',
	coerce => 1,
	required => 1,
);

has content_file => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

sub content {
	my ( $self ) = @_;
	return join("\n",io($self->content_file)->slurp);
}

sub content_text {
	my ( $self ) = @_;
	HTML::Restrict->new->process($self->content);
}

sub content_abstract {
	my ( $self ) = @_;
	my @lines = io($self->content_file)->slurp;
	my $abstract = "";
	for (@lines) {
		$_ =~ s/^\s+//;
		$_ =~ s/\s+$//;
		last if $_ eq '<!-- break -->';
		$abstract .= $_;
	}
	return $abstract;
}

sub content_abstract_text {
	my ( $self ) = @_;
	HTML::Restrict->new->process($self->content_abstract);
}

1;