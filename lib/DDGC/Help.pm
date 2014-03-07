package DDGC::Help;

use Moose;
use DDGC::Search::Client;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	weak_ref => 1,
	required => 1,
);

has index_name => (
	is => 'ro',
        default => sub { 'help' },
);

with 'DDGC::Role::Searchable';

1;

# ABSTRACT: Convenient class for DDG's Help system

__DATA__

=pod

=head1 SYNOPSIS

See L<DDGC>.

=head1 DESCRIPTION

This provides base functionality to the help system (L<https://duck.co/help>).

=head1 SEE ALSO

=over 4

=item L<DDGC>

The DDGC module is the only place this module is used.

=item L<DDGC::Web::Controller::Help>

The web controller (where specific requests are handled).

=item L<DDGC::DB::Result::Help>

The database model for Help articles.

=back

=cut
