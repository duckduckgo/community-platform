package DDGC::Search;
# ABSTRACT: postgres fulltext searching

use Moose;
use DBIx::Class::ResultClass::HashRefInflator;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
	handles => [qw/ rs /],
);

sub topic_suggest {
	my ( $self, $searchtext ) = @_;
	my $searchterms = join ' | ', split /\s+/, $searchtext =~ s/[^\w ]//rg;
	$searchterms.=":*";

	$self->rs('Thread::Suggest')->search({}, {
		cache_for => 600,
		result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		bind => [ $searchterms, $searchterms ],
	})->all;
}

no Moose;
__PACKAGE__->meta->make_immutable;
