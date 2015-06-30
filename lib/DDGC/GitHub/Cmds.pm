package DDGC::GitHub::Cmds;
# ABSTRACT: 

use Moose;
use URI::Escape;
use URI;

with 'Net::GitHub::V3::Query';

sub user {
    my ( $self, $user ) = @_;
    my $u = $user ? "/users/" . uri_escape($user) : '/user';
    return $self->query($u);
}

sub list_user {
    my ($self, $user, $type) = @_;
    $user ||= $self->u;
    $type ||= 'all';
    my $u = "/users/" . uri_escape($user) . "/repos";
    $u .= '?type=' . $type if $type ne 'all';
    return $self->query($u);
}

sub list_org {
    my ($self, $org, $type) = @_;
    $type ||= 'all';
    my $u = "/orgs/" . uri_escape($org) . "/repos";
    $u .= '?type=' . $type if $type ne 'all';
    return $self->query($u);
}

sub issues {
    my ($self, %args) = @_;
    my $owner = $args{owner} || die "owner param required";
    my $repo  = $args{repo}  || die "repo param required";
    my $uri   = URI->new("/repos/$owner/$repo/issues");
    $uri->query_form(%args);
    return $self->query($uri->as_string);
}

sub issue_comments {
    my ($self, %args) = @_;
    my $owner  = $args{owner}  || die "owner param required";
    my $repo   = $args{repo}   || die "repo param required";
    my $number = $args{number} || die "number param required";
    my $uri = URI->new("/repos/$owner/$repo/issues/$number/comments");
    $uri->query_form(%args);
    return $self->query($uri->as_string);
}

__build_methods(__PACKAGE__, (
  branches        => { url => "/repos/%s/%s/branches"           },
  commits         => { url => "/repos/%s/%s/commits"            },
  commits_since   => { url => "/repos/%s/%s/commits?since=%s"   },
  pulls           => { url => "/repos/%s/%s/pulls?state=all"    },
  pulls_comments  => { url => "/repos/%s/%s/pulls/%s/comments"  },
  issues_since    => { url => "/repos/%s/%s/issues?since=%s"    },
));

1;
