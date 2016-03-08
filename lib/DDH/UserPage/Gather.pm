package DDH::UserPage::Gather;

use strict;
use warnings;

use Moo;

use HTTP::Tiny;
use Try::Tiny;
use JSON::MaybeXS;
use List::MoreUtils qw/ uniq /;
use Carp;

has repo_url => (
    is => 'ro',
    default => 'https://duck.co/ia/repo/all/json?all_milestones=1',
);

has http => ( is => 'lazy' );
sub _build_http {
    HTTP::Tiny->new;
}

has json => ( is => 'lazy' );
sub _build_json {
    JSON::MaybeXS->new(utf8 => 1);
}

sub ia_repo {
    my ( $self ) = @_;
    my $response = $self->http->get( $self->repo_url );

    if ( !$response->{success} ) {
        croak "$response->{status} $response->{reason}";
    }

    $self->json->decode( $response->{content} );
}

sub transform {
    my ( $self, $ia ) = @_;
    my $transform = {};

    for my $ia_id ( keys $ia ) {
        my @contributors;
        $ia->{ia_id} = $ia_id;

        if ( $ia->{$ia_id}->{developer} ) {

            for my $developer ( @{ $ia->{$ia_id}->{developer} } ) {

                if ( $developer->{type} &&
                     $developer->{type} eq 'github' ) {

                    ( my $login = $developer->{url} ) =~
                        s{https://github.com/(.*)/?}{$1};

                    push @contributors, lc $login;
                }
            }

        }

        if ( $ia->{$ia_id}->{attribution} ) {

            for my $attribution ( keys $ia->{$ia_id}->{attribution} ) {
                push @contributors, map { lc $_->{loc} }
                  grep { $_->{type} && $_->{type} eq 'github' }
                      @{ $ia->{$ia_id}->{attribution}->{ $attribution } };
            }

        }

        for my $contributor ( uniq @contributors ) {
            # Some of our github logins contain '/' at the end?
            $contributor =~ s{/$}{};
            my $milestone = $ia->{$ia_id}->{dev_milestone} || 'planning';
            push @{ $transform->{$contributor}->{ $milestone } }, $ia->{$ia_id};
        }
    }

    return $transform;
}

sub contributors {
    my ( $self ) = @_;
    $self->transform( $self->ia_repo );
}

1;

