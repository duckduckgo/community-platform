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

	$self->rs('Thread')->search({
		-and => [
			'me.forum' => $self->ddgc->config->id_for_forum('general'),
			'me.migrated_to_idea' => undef,
			\[
				'to_tsvector(me.title) ||
				 to_tsvector(comment.content)
				 @@ to_tsquery( ? )', $searchterms
			],
		],
	},
	{
		rows => 4,
		cache_for => 600,
		result_class => 'DBIx::Class::ResultClass::HashRefInflator',
		prefetch => [qw/ comment /],
	})->all;
}

no Moose;
__PACKAGE__->meta->make_immutable;
