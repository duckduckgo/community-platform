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

sub list_user_repos {
    my ($self, $user, $type) = @_;
    $user ||= $self->u;
    $type ||= 'all';
    my $u = "/users/" . uri_escape($user) . "/repos";
    $u .= '?type=' . $type if $type ne 'all';
    return $self->query($u);
}

sub list_org_repos {
    my ($self, $org, $type) = @_;
    $type ||= 'all';
    my $u = "/orgs/" . uri_escape($org) . "/repos";
    $u .= '?type=' . $type if $type ne 'all';
    return $self->query($u);
}

sub commits {
    my ($self, %args) = @_;

    my $owner = $args{owner} || die "owner param required";
    my $repo  = $args{repo}  || die "repo param required";
    my $uri   = URI->new("/repos/$owner/$repo/commits");
    $uri->query_form(%args);

    return $self->_drain_api($uri);
}

sub issues {
    my ($self, %args) = @_;

    my $owner = $args{owner} || die "owner param required";
    my $repo  = $args{repo}  || die "repo param required";
    my $uri   = URI->new("/repos/$owner/$repo/issues");
    $uri->query_form(%args);

    return $self->_drain_api($uri);
}

sub pulls {
    my ($self, %args) = @_;

    my $owner = $args{owner} || die "owner param required";
    my $repo  = $args{repo}  || die "repo param required";
    my $uri   = URI->new("/repos/$owner/$repo/pulls");
    $uri->query_form(%args);

    return $self->_drain_api($uri);
}

sub forks {
    my ($self, %args) = @_;

    my $owner = $args{owner} || die "owner param required";
    my $repo  = $args{repo}  || die "repo param required";
    my $uri   = URI->new("/repos/$owner/$repo/forks");
    $uri->query_form(%args);

    return $self->_drain_api($uri);
}

sub comments {
    my ($self, %args) = @_;

    my $owner  = $args{owner}  || die "owner param required";
    my $repo   = $args{repo}   || die "repo param required";
    my $uri = URI->new("/repos/$owner/$repo/issues/comments");
    $uri->query_form(%args);

    return $self->_drain_api($uri);
}

sub _drain_api {
    my ($self, $uri) = @_;

    my $results = $self->query($uri->as_string);

    while ($self->has_next_page) {
        push @$results, @{ $self->next_page };
    }

    return $results;
}

__build_methods(__PACKAGE__, (
  branches        => { url => "/repos/%s/%s/branches"           },
));

1;
