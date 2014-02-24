package DDGC::Search::Server;

use Moose;
use Dezi::MultiTenant;
use Dezi::Config;
use Lingua::Stem;

has indices => (
    is => 'ro',
    isa => 'ArrayRef',
    lazy_build => 1,
);

sub _build_indices {
    [qw(help thread idea)]
}

has stemmer => (
    is => 'ro',
    lazy_build => 1,
    handles => ['stem'],
);

sub _build_stemmer {
    return Lingua::Stem->new;
}

sub app {
    my $self = shift;
    Dezi::MultiTenant->app({
        map {
            '/'.$_ => {
                base_uri => $self->config->dezi_uri,
                engine_config => {
                    type => 'Lucy',
                    index => ["$_.index"],
                    indexer_config => {
                        config => {
                            UndefinedMetaTags => 'autoall',
                            FuzzyIndexingMode => 'Stemming_en1',
                        }
                    },
                    searcher_config => {
                        max_hits => 1000,
                        find_relevant_fields => 1,
                        qp_config => {
                            dialect => 'Lucy',
                            null_term => 'NULL',
                            default_field => ['swishtitle', 'swishdescription'],
                        },
                    },
                },
            }
        } @{$self->indices}
    });
}

has config => (
    is => 'ro',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
1;

# ABSTRACT: A Dezi-based opensearch server

__DATA__

=pod

=head1 SYNOPSIS

    my $runner = Plack::Runner->new;
    my $server = DDGC::Search::Server->new(config => $ddgc->config);

    $runner->parse_options(@ARGV);
    $runner->run($server->app);

=cut
