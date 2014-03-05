package DDGC::Role::Searchable;

use Moose::Role;

requires 'index_name';

has search_engine => (
	isa => 'DDGC::Search::Client',
	is => 'ro',
	lazy_build => 1,
	lazy => 1,
        handles => [qw(search index)],
);

sub _build_search_engine {
	my $self = shift;
	DDGC::Search::Client->new(
		ddgc => $self->ddgc,
		type => $self->index_name,
	)
}

1;

# ABSTRACT: Provide a search engine to consuming classes

__DATA__

=pod

=head1 SYNOPSIS

    has index_name => (
        is => 'ro',
        default => sub { 'some_index_name' },
    );

    with 'DDGC::Role::Searchable';

=head1 DESCRIPTION

Classes consuming this role will get some basic functionality for search
built in. This uses the attribute C<index_name> to determine which search
index to use. See L<DDGC::Search::Server> for the index definitions.

=head1 ATTRIBUTES

=over 4

=item C<search_engine>

Isa L<DDGC::Search::Client> built with the C<type> given by C<index_name>.
C<handles> search and index, so ->search and ->index on the consuming class
are passed along to the C<search_engine>.

=back

=head1 SEE ALSO

=over 4

=item L<DDGC::Search::Server>

Defines the indices which can be used here.

=item L<DDGC::Search::Client>

The search client this wraps for you.

=back

=cut
