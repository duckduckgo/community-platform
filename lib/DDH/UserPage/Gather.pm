package DDH::UserPage::Gather;

use strict;
use warnings;

use Moo;
use DDGC;
use DDGC::Web;

use HTTP::Tiny;
use Try::Tiny;
use JSON::MaybeXS;
use Plack::Builder;
use Plack::Test;
use HTTP::Request::Common;
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

has ddgc => ( is => 'lazy' );
sub _build_ddgc {
    DDGC->new;
}

has app => ( is => 'lazy' );
sub _build_app {
    Plack::Test->create(
        builder {
            mount '/' => DDGC::Web->new->psgi_app;
        }
    );
}

sub ia_repo {
    my ( $self ) = @_;
    my $response = $self->http->get( $self->repo_url );

    if ( !$response->{success} ) {
        croak "$response->{status} $response->{reason}";
    }

    $self->json->decode( $response->{content} );
}

sub ia_local {
    my ( $self ) = @_;
    my $response = $self->app->request( GET '/ia/repo/all/json?all_milestones=1' );

    if ( !$response->is_success ) {
        croak sprintf( "%s %s", $response->code, $response->message );
    }

    $self->json->decode( $response->decoded_content );
}

sub gh_issues {
    my ( $self, $username ) = @_;
    my @issues;

    if ( my $gh_user = $self->ddgc->rs('GitHub::User')->find({ login => $username }) ) {

        my $gh_id = $gh_user->id;
        @issues = $self->ddgc->rs('GitHub::Issue')->search({
           ( -or => [{ 'me.github_user_id_assignee' => $gh_id },
                   { 'me.github_user_id' => $gh_id }]
           ),
           ( 'me.state' => 'open' ),
        },
        {
            join => [ qw/ github_repo / ],
            columns => [ qw/ id state github_repo_id title number isa_pull_request github_repo.full_name / ],
            collapse => 1,
            group_by => 'me.id',
            result_class => 'DBIx::Class::ResultClass::HashRefInflator',
        });
    }

    return \@issues;
}

sub find_ia {
    my ( $self, $issue ) = @_;
    
    if ( my $ia_issue = $self->ddgc->rs('InstantAnswer::Issues')->search({ issue_id => $issue->{number} })->first ) {
        $issue->{ia_id} = $ia_issue->instant_answer_id;

        if ( my $ia = $self->ddgc->rs('InstantAnswer')->find({ meta_id => $ia_issue->instant_answer_id }) ) {
            $issue->{ia_name} = $ia->name;
        }
        
    }

    return $issue;
}

sub transform {
    my ( $self, $ia ) = @_;
    my $transform = {};

    for my $ia_id ( keys $ia ) {
        my @contributors;
        my @topics;
        $ia->{ia_id} = $ia_id;

        if ( $ia->{$ia_id}->{developer} ) {

            for my $developer ( @{ $ia->{$ia_id}->{developer} } ) {

                if ( $developer->{type} &&
                     $developer->{type} eq 'github' ) {

                    ( my $login = $developer->{url} ) =~
                        s{https://github.com/(.*)/?}{$1};

                    push @contributors, $login;
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
            my $lc_contributor = lc $contributor;
            $lc_contributor =~ s{/$}{};
            my $milestone = $ia->{$ia_id}->{dev_milestone} || 'planning';
            push @{ $transform->{$lc_contributor}->{ia}->{ $milestone } }, $ia->{$ia_id};
            
            #Append GitHub issues and pull requests
            if ( (my $issues = $self->gh_issues( $contributor )) && !($transform->{$lc_contributor}->{pulls}) && !($transform->{$lc_contributor}->{issues}) ) {
                for my $issue ( uniq @{ $issues } ) {
                    # Pair the issue to an IA if possible
                    $issue = $self->find_ia( $issue );

                    if ( $issue->{isa_pull_request} ) {
                        push @{ $transform->{$lc_contributor}->{pulls} }, $issue;
                    } else {
                        push @{ $transform->{$lc_contributor}->{issues} }, $issue;
                    }
                }
            }

            # Append topics
            if ( $ia->{$ia_id}->{topic} && ( $ia->{$ia_id}->{dev_milestone} eq 'live' ) ) {
                for my $topic ( @{ $ia->{$ia_id}->{topic} } ) {

                    my $topic_count = $transform->{$lc_contributor}->{topics}->{$topic};
                    $topic_count = $topic_count? $topic_count + 1 : 1;
                    $transform->{$lc_contributor}->{topics}->{$topic} = $topic_count;
                }
            }
        }
    }

    return $transform;
}

sub contributors {
    my ( $self ) = @_;
    $self->transform( $self->ia_local );
}

1;

