package DDGC::Search::Server;

use Moose;
use Dezi::MultiTenant;
use Dezi::Config;

has indices => (
    is => 'ro',
    isa => 'ArrayRef',
    lazy_build => 1,
);

sub _build_indices {
    [qw(help thread idea)]
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
                },
                indexer_config => {
                    config => {
                        UndefinedMetaTags => 'auto',
                        DefaultContents => 'TXT',
                    }
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

__DATA__

=pod

=encoding UTF-8

=head1 NAME

DDGC::Search::Server - A Dezi-based opensearch server

=head1 SYNOPSIS

    my $runner = Plack::Runner->new;
    my $server = DDGC::Search::Server->new(config => $ddgc->config);

    $runner->parse_options(@ARGV);
    $runner->run($server->app);

=cut
