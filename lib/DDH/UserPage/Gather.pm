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
use Encode qw(encode_utf8);

binmode STDOUT, ':encoding(UTF-8)';
binmode STDERR, ':encoding(UTF-8)';

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
    my ( $self ) = @_;

    my @issues = $self->ddgc->rs('GitHub::Issue')->search({
      state => 'open',
    },
    {
        join => [ qw/ github_repo github_user_assignee / ], 
        columns => [ qw/ id state github_repo_id comments tags title number isa_pull_request github_repo.full_name github_user_id github_user_id_assignee created_at updated_at github_user_assignee.login github_user_assignee.gh_data/ ],
        collapse => 1,
        group_by => [ qw/ me.id github_user_assignee.id github_repo.full_name / ],
        result_class => 'DBIx::Class::ResultClass::HashRefInflator',
    });

    for my $issue ( @issues ) {
        $issue = $self->find_ia( $issue );
        my @tags;
        my %temp_tags;
        my $original_tags = $issue->{tags}? decode_json($issue->{tags}) : '';
        if ($original_tags) {
            for my $tag (@{$original_tags}) {
                if (!$temp_tags{$tag->{name}}) {
                    $temp_tags{$tag->{name}} = {
                        name => $tag->{name},
                        color => $tag->{color}
                    };
                }

                push @tags, $tag;
            }
        }

        $issue->{tags} = \@tags;
        if ( $issue->{github_user_assignee} && $issue->{github_user_assignee}->{gh_data} ) {
            $issue->{github_user_assignee}->{gh_data} = encode_utf8( $issue->{github_user_assignee}->{gh_data} );
            my $gh_data = $self->json->decode( $issue->{github_user_assignee}->{gh_data} );
            $issue->{github_user_assignee}->{avatar_url} = $gh_data->{avatar_url};
            delete $issue->{github_user_assignee}->{gh_data};
        }
    }

    return \@issues;
}

sub closed_gh_issues {
    my ( $self, $gh_id ) = @_;

    my $closed_pulls = $self->ddgc->rs('GitHub::Issue')->search({
      ( -or => [{ 'me.github_user_id_assignee' => $gh_id },
              { 'me.github_user_id' => $gh_id }]
      ),
      ( state => 'closed' ),
      ( isa_pull_request => 1 ),
    })->count;

    my $closed_issues = $self->ddgc->rs('GitHub::Issue')->search({
      ( -or => [{ 'me.github_user_id_assignee' => $gh_id },
              { 'me.github_user_id' => $gh_id }]
      ),
      ( state => 'closed' ),
      ( isa_pull_request => 0 ),
    })->count;

    my %gh_issues = (
        closed_pulls => $closed_pulls,
        closed_issues => $closed_issues
    );

    return \%gh_issues;
}

sub gh_user_id {
    my ( $self, $username ) = @_;

    if ( my $gh_user = $self->ddgc->rs('GitHub::User')->find({ login => $username }) ) {
        return $gh_user->id;
    }
}

sub find_ia {
    my ( $self, $issue ) = @_;
    
    my $repo = $issue->{github_repo}->{full_name};
    $repo =~ s/zeroclickinfo-//;
    $repo =~ s/duckduckgo\///;
    
    if ( my $ia_issue = $self->ddgc->rs('InstantAnswer::Issues')->find({ issue_id => $issue->{number}, repo => $repo }) ) {
        $issue->{ia_id} = $ia_issue->instant_answer_id;

        if ( my $ia = $self->ddgc->rs('InstantAnswer')->find({ meta_id => $ia_issue->instant_answer_id }) ) {
            $issue->{ia_name} = $ia->name;
        }
    }

    return $issue;
}

sub get_avatar {
    my ( $self, $developer ) = @_;

    if ( my $gh_user = $self->ddgc->rs('GitHub::User')->search( \[ 'LOWER(login) = ?', lc( $developer ) ] )->one_row ) {
        my $gh_data = $gh_user->gh_data;
        return $gh_data->{avatar_url} if $gh_data;
    }
}

sub transform {
    my ( $self, $ia ) = @_;
    my $transform = {};

    my $issues = $self->gh_issues();

    for my $ia_id ( keys $ia ) {
        my @contributors;
        my @topics;
        $ia->{ia_id} = $ia_id;

        if ( $ia->{$ia_id}->{developer} ) {

            if ( ref $ia->{$ia_id}->{developer} eq 'ARRAY' ) {

                $ia->{$ia_id}->{contributors} = [];
                
                for my $developer ( @{ $ia->{$ia_id}->{developer} } ) {


                    if ( ( ref $developer eq 'HASH' ) && $developer->{type} &&
                         $developer->{type} eq 'github' ) {

                        ( my $login = $developer->{url} ) =~
                            s{https://github.com/(.*)/?}{$1};

                        my %contributor = (
                            username => $login,
                            avatar_url => $self->get_avatar($login)
                        );

                        push @{ $ia->{$ia_id}->{contributors} }, \%contributor;
                        push @contributors, $login;
                    }
                }

            }
            else {
                use DDP;
                warn sprintf("IA $ia_id - 'developer' is not an array:\n%s\n",
                    p $ia->{$ia_id}->{developer});
            }

        }

        # Issues count for this IA
        if ( my $issues_count = $self->ddgc->rs('InstantAnswer::Issues')->search({ instant_answer_id => $ia_id, is_pr => 0, status => 'open' })->count ) {

            $ia->{$ia_id}->{issues_count} = $issues_count;
        }

        # PRs count for this IA
        if ( my $pulls = $self->ddgc->rs('InstantAnswer::Issues')->search({ instant_answer_id => $ia_id, is_pr => 1, status => 'open' })->count ) {
        
            $ia->{$ia_id}->{prs_count} = $pulls;
        }

        # Maintained IAs for each contributor
        if ( ( my $maintainer = $ia->{$ia_id}->{maintainer} ) && ( $ia->{$ia_id}->{maintainer}->{github} ) ) {
            push @contributors, $maintainer->{github};
            push @{ $transform->{lc($maintainer->{github})}->{maintained} }, $ia->{$ia_id};
        }

        if ( $ia->{$ia_id}->{attribution} ) {

            for my $attribution ( keys $ia->{$ia_id}->{attribution} ) {
                push @contributors, map { $_->{loc} }
                  grep { $_->{type} && $_->{type} eq 'github' }
                      @{ $ia->{$ia_id}->{attribution}->{ $attribution } };
            }

        }

        for my $contributor ( uniq @contributors ) {
            # Some of our github logins contain '/' at the end?
            $contributor =~ s{/$}{};
            my $lc_contributor = lc $contributor;
            my $milestone = $ia->{$ia_id}->{dev_milestone} || 'planning';
            push @{ $transform->{$lc_contributor}->{ia}->{ $milestone } }, $ia->{$ia_id};
            $transform->{ $lc_contributor }->{ original_login } ||= $contributor;

            #Append GitHub issues and pull requests
            my $gh_id = $self->gh_user_id( $contributor );
            if ( $gh_id && ( my $closed_issues = $self->closed_gh_issues( $gh_id ) ) && !( $transform->{$lc_contributor}->{pulls}) && !($transform->{$lc_contributor}->{issues}) ) {
                if ( my $closed_issues = $self->closed_gh_issues( $gh_id ) ) {
                    $transform->{$lc_contributor}->{closed_pulls} = $closed_issues->{closed_pulls};
                    $transform->{$lc_contributor}->{closed_issues} = $closed_issues->{closed_issues};
                }

                if ( $issues ) {
                    $transform->{$lc_contributor}->{pulls_assigned} = {};
                    $transform->{$lc_contributor}->{pulls_created} = {};
                    $transform->{$lc_contributor}->{issues_assigned} = {};
                    $transform->{$lc_contributor}->{issues_created} = {};

                    for my $issue ( @{ $issues } ) {
                        # Pair the issue to an IA if possible
                        my $issue_assignee = $issue->{github_user_id_assignee};
                        my $issue_opener = $issue->{github_user_id};
                        my $suffix_key = 'other';
                        if ( $issue_assignee && ( $gh_id eq $issue_assignee ) ) {
                            $suffix_key = 'assigned';
                        } elsif ( $issue_opener && ( $gh_id eq $issue_opener ) ) {
                            $suffix_key = 'created';
                        }
                        
                        if ( $issue->{isa_pull_request} ) {
                            my $pull_key = 'pulls_' . $suffix_key;
                            $transform->{$lc_contributor}->{$pull_key}->{$issue->{id}} = $issue;
                        } else {
                            my $issue_key = 'issues_' . $suffix_key;
                            $transform->{$lc_contributor}->{$issue_key}->{$issue->{id}} = $issue;
                        }
                    }
                }
            }

            # Append topics
            if ( $ia->{$ia_id}->{topic} ) {
                for my $topic ( @{ $ia->{$ia_id}->{topic} } ) {

                    my $topic_count = $transform->{$lc_contributor}->{topics}->{$topic};
                    $topic_count = $topic_count? $topic_count + 1 : 1;
                    $transform->{$lc_contributor}->{topics}->{$topic} = $topic_count;
                }
            }

            # Public GH data
            my $gh_data;
            try {
                $gh_data = $self->ddgc->github->find_or_update_user( $contributor );
            } catch {
                warn "Unable to get gh_data for $contributor";
            };
            if ( !$gh_data ) {
                delete $transform->{$lc_contributor};
                next;
            }
            $transform->{$lc_contributor}->{gh_data} = $gh_data->gh_data;
        }
    }

    return $transform;
}

sub contributors {
    my ( $self ) = @_;
    $self->transform( $self->ia_local );
}

1;

