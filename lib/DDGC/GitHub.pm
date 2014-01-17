package DDGC::GitHub;
# ABSTRACT: 

use Moose;
use Net::GitHub;
use DateTime::Format::ISO8601;

has ddgc => (
  isa => 'DDGC',
  is => 'ro',
  weak_ref => 1,
  required => 1,
);

has gh => (
  is => 'ro',
  lazy_build => 1,
);

sub _build_gh {
  Net::GitHub->new( access_token => $_[0]->ddgc->config->github_token )
}

sub parse_datetime {
  $_[0]
    ? DateTime::Format::ISO8601->parse_datetime( $_[0] ) 
    : undef
}

sub update_database {
  my ( $self ) = @_;
  $self->update_repos($self->ddgc->config->github_org,1);
}

sub find_or_update_user {
  my ( $self, $login ) = @_;
  my $user = $self->ddgc->rs('GitHub::User')->find({ login => $login });
  return $user if $user;
  return $self->update_user($login);
}

sub update_user {
  my ( $self, $login ) = @_;
  my $user = $self->gh->user->show($login);
  $self->ddgc->rs('GitHub::User')->update_or_create({
    github_id => $user->{id},
    (map { $_ => $user->{$_} } qw(
      login
      gravatar_id
      name
      company
      blog
      location
      email
      bio
      type
    )),
    (map { $_ => parse_datetime($user->{$_}) } qw(
      created_at
      updated_at
    )),
    gh_data => $user,
  },{
    key => 'github_user_github_id',
  });
}

sub update_repos {
  my ( $self, $login, $company ) = @_;
  my $owner = $self->update_user($login);
  my $ngh_repos = $self->gh->repos;
  my @repos = $owner->type eq 'Organization'
    ? @{$self->gh->repos->list_org($login)}
    : @{$self->gh->repos->list_user($login)};
  while ($ngh_repos->has_next_page) {
    push @repos, @{$ngh_repos->query($ngh_repos->next_url)};
  }
  for (@repos) {
    $self->update_user_repo_from_data($owner,$_,$company);
  }
}

sub update_user_repo_from_data {
  my ( $self, $gh_user, $repo, $company ) = @_;
  my $gh_repo = $gh_user->update_or_create_related('github_repos',{
    github_id => $repo->{id},
    company_repo => $company ? 1 : 0,
    (map { $_ => $repo->{$_} } qw(
      forks_count
      full_name
      description
      watchers_count
      open_issues_count
    )),
    (map { $_ => parse_datetime($repo->{$_}) } qw(
      created_at
      updated_at
      pushed_at
    )),
    company_repo => $company ? 1 : 0,
    gh_data => $repo,
  },{
    key => 'github_repo_github_id',
  });
  $self->update_user_repo_commits($gh_repo);
  return $gh_repo;
}

sub update_user_repo_commits {
  my ( $self, $gh_repo ) = @_;
  return unless $gh_repo->pushed_at;
  use DDP; p($gh_repo->full_name);
  my $ngh_repos = $self->gh->repos;
  my @gh_commits;
  for (@{$ngh_repos->commits(
    $gh_repo->owner_name,$gh_repo->repo_name
  )}) {
    push @gh_commits, $self->update_user_repo_commit_from_data($gh_repo,$_);
  }
  while ($ngh_repos->has_next_page) {
    for (@{$ngh_repos->query($ngh_repos->next_url)}) {
      push @gh_commits, $self->update_user_repo_commit_from_data($gh_repo,$_);
    }
  }
  my $count = scalar @gh_commits;
  use DDP; p($count);
  return \@gh_commits;
}

sub update_user_repo_commit_from_data {
  my ( $self, $gh_repo, $commit ) = @_;
  return $gh_repo->update_or_create_related('github_commits',{
    defined $commit->{author}
      ? ( github_user_id_author => $self->find_or_update_user($commit->{author}->{login})->id )
      : (),
    defined $commit->{committer}
      ? ( github_user_id_committer => $self->find_or_update_user($commit->{committer}->{login})->id )
      : (),
    author_date => parse_datetime($commit->{commit}->{author}->{date}),
    author_email => $commit->{commit}->{author}->{email},
    author_name => $commit->{commit}->{author}->{name},
    committer_date => parse_datetime($commit->{commit}->{committer}->{date}),
    committer_email => $commit->{commit}->{committer}->{email},
    committer_name => $commit->{commit}->{committer}->{name},
    sha => $commit->{sha},
    message => $commit->{message},
    gh_data => $commit,
  },{
    key => 'github_commit_sha_github_repo_id',
  });
}

1;
