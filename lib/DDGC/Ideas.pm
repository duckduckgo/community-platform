package DDGC::Ideas;

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
	default => sub { 'idea' },
);

with 'DDGC::Role::Searchable';

1;

# ABSTRACT: DuckDuckGo Instant Answer Suggestions

__DATA__

=pod

=head1 SYNOPSIS

See L<DDGC>.

=head1 DESCRIPTION

This provides some handy functions for ideas (L<https://duck.co/ideas>)

=head1 SEE ALSO

=over 4

=item L<DDGC>

This module is used in DDGC, see its code for example usage.

=item L<DDGC::Web::Controller::Ideas>

The web controller (where specific requests are handled).

=item L<DDGC::DB::Result::Idea>

The database model for Instant Answer ideas.

=back

=cut
