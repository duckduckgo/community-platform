package DDGC::GitHub;
# ABSTRACT: 

use Moose;
use Net::GitHub;
use DDGC::GitHub::Cmds;
use DateTime::Format::ISO8601;
use DateTime::Duration;
use HTTP::Request;
use JSON::MaybeXS;
use DDP;

has ddgc => (
  isa => 'DDGC',
  is => 'ro',
  weak_ref => 1,
  required => 1,
);

sub gh_api { DDGC::GitHub::Cmds->new($_[0]->net_github->args_to_pass) }

has net_github => (
  is => 'ro',
  lazy_build => 1,
);

sub _build_net_github {
  Net::GitHub->new( access_token => $_[0]->ddgc->config->github_token )
}

sub validate_session_code {
  my ( $self, $code, $user ) = @_;
  my $req = HTTP::Request->new('POST','https://github.com/login/oauth/access_token');
  $req->header('Content-type','application/json');
  $req->header('Accept','application/json');
  $req->content(JSON::MaybeXS->new->utf8(1)->encode({
    client_id => $self->ddgc->config->github_client_id,
    client_secret => $self->ddgc->config->github_client_secret,
    code => $code,
  }));
  my $response = $self->ddgc->http->request($req);
  my $result = JSON::MaybeXS->new->utf8(1)->decode($response->content);
  return undef unless defined $result->{access_token};
  my $net_github = $self->user_net_github($result->{access_token});
  my $gh_user = $self->update_user_from_data(scalar $net_github->user->show);
  my %scopes = map { $_ => 1 } split(",",$result->{scope});
  $gh_user->scope_public_repo($scopes{public_repo} ? 1 : 0);
  $gh_user->scope_user_email(
    $scopes{'user:email'}
      ? 1
      : $scopes{'user'}
        ? 1
        : 0
  );
  $gh_user->access_token($result->{access_token});
  $gh_user->users_id($user->id) if ($user);
  $gh_user->update;
  return $gh_user;
}

sub user_net_github {
  my ( $self, $access_token ) = @_;
  my $net_github = Net::GitHub->new( access_token => $access_token );
  my $gh_api = DDGC::GitHub::Cmds->new($net_github->args_to_pass);
  return wantarray
    ? ($net_github, $gh_api)
    : $net_github;
}

sub parse_datetime {
  $_[0]
    ? DateTime::Format::ISO8601->parse_datetime( $_[0] ) 
    : undef
}

sub datetime_str {
  $_[0]->strftime("%FT%TZ");
}

sub one_second {
    return DateTime::Duration->new(seconds => 1);
}

sub update_database {
  my ( $self ) = @_;
  $self->update_repos($self->ddgc->config->github_org, 1);
}

sub find_or_update_user {
  my ( $self, $login ) = @_;
  my $user = $self->ddgc->rs('GitHub::User')->find({ login => $login });
  return $user if $user;
  return $self->update_user($login);
}

sub update_user {
  my ( $self, $login ) = @_;
  my $user = $self->gh_api->user($login);
  return $self->update_user_from_data($user);
}

sub update_user_from_data {
  my ( $self, $user ) = @_;
  return $self->ddgc->rs('GitHub::User')->update_or_create({
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
  my $gh_api = $self->gh_api;
  my @repos = $owner->type eq 'Organization'
    ? @{$gh_api->list_org_repos($login)}
    : @{$gh_api->list_user_repos($login)};
  while ($gh_api->has_next_page) {
    push @repos, @{$gh_api->next_page};
  }
  my @company_repos = $self->ddgc->rs('GitHub::Repo')->search({
      company_repo => 1,
  },{
      columns => ['full_name']
  })->all;
  for my $repo (@repos) {
    if (!$company && $repo->{fork} && !$repo->{private}) {
        # Check to see if this is a fork and has the same name as a duckduckgo/ repo
        $company = scalar grep { 
            $_->full_name eq $self->ddgc->config->github_org.'/'.$repo->{name}
        } @company_repos;
        next unless $company;
        $self->update_user_repo_from_data($owner,$repo,$company) unless $repo->{private};
    }
    else {
        my $company = $self->want_repo($repo->{full_name}) || next;
        $self->update_user_repo_from_data($owner,$repo,$company);
    }
  }
}

sub wanted_repos {
    return qw|
        duckduckgo/zeroclickinfo-spice
    |;
#        duckduckgo/zeroclickinfo-fathead
#        duckduckgo/zeroclickinfo-goodies
#        duckduckgo/zeroclickinfo-longtail
}

sub want_repo {
    my ($self, $name) = @_;

    for my $wanted ($self->wanted_repos) {
        return $wanted if $name =~ /$wanted/;
    }

    return 0;
}

sub update_user_repo_from_data {
    my ($self, $gh_user, $repo, $company) = @_;

    my %columns;
    $columns{github_id}         = $repo->{id};
    $columns{company_repo}      = $company ? 1 : 0;
    $columns{forks_count}       = $repo->{forks_count};
    $columns{full_name}         = $repo->{full_name};
    $columns{description}       = $repo->{description};
    $columns{watchers_count}    = $repo->{watchers_count};
    $columns{open_issues_count} = $repo->{open_issues_count};
    $columns{created_at}        = parse_datetime($repo->{created_at});
    $columns{updated_at}        = parse_datetime($repo->{updated_at});
    $columns{pushed_at}         = parse_datetime($repo->{pushed_at});
    $columns{gh_data}           = $repo;
    
    my $gh_repo = $gh_user
        ->related_resultset('github_repos')
        ->update_or_create(\%columns, { key => 'github_repo_github_id' });

    printf "Updating %s/%s\n", $gh_repo->owner_name, $gh_repo->repo_name;

    print "   commits...\n";
    $self->update_repo_commits($gh_repo);
    print "   issues...\n";
    $self->update_repo_issues($gh_repo);
    print "   pulls...\n";
    $self->update_repo_pulls($gh_repo);
    print "   comments...\n";
    $self->update_repo_comments($gh_repo);
    print "   forks...\n";
    $self->update_repo_forks($gh_repo);
    print "   branches...\n";
    $self->update_repo_branches($gh_repo);
    return $gh_repo;
}

sub update_repo_pulls {
    my ($self, $gh_repo) = @_;

    my $latest_pull = $gh_repo
        ->related_resultset('github_pulls')
        ->most_recent;

    my %params;
    $params{owner}  = $gh_repo->owner_name;
    $params{repo}   = $gh_repo->repo_name;
    $params{state}  = 'all';
    $params{since}  = datetime_str($latest_pull->updated_at + $self->one_second)
        if $latest_pull;

    my $pulls_data = $self->gh_api->pulls(%params);

    my @gh_pulls;
    push @gh_pulls, $self->update_repo_pull_from_data($gh_repo, $_)
        for @$pulls_data;

    return \@gh_pulls;
}

sub update_repo_pull_from_data {
    my ( $self, $gh_repo, $pull ) = @_;

    my %columns;
    $columns{github_id}      = $pull->{id};
    $columns{github_user_id} = $self->find_or_update_user($pull->{user}->{login})->id;
    $columns{title}          = $pull->{title};
    $columns{body}           = $pull->{body};
    $columns{state}          = $pull->{state};
    $columns{number}         = $pull->{number};
    $columns{created_at}     = parse_datetime($pull->{created_at});
    $columns{updated_at}     = parse_datetime($pull->{updated_at});
    $columns{closed_at}      = parse_datetime($pull->{closed_at});
    $columns{merged_at}      = parse_datetime($pull->{merged_at});
    $columns{gh_data}        = $pull;

    return $gh_repo
        ->related_resultset('github_pulls')
        ->update_or_create(\%columns, { key => 'github_pull_github_id' });
}

sub update_repo_comments {
    my ($self, $gh_repo) = @_;

    my $latest_comment = $gh_repo
        ->related_resultset('github_comments')
        ->most_recent;

    my %params;
    $params{owner}  = $gh_repo->owner_name;
    $params{repo}   = $gh_repo->repo_name;
    $params{since}  = datetime_str($latest_comment->updated_at + $self->one_second)
        if $latest_comment;

    my $comments_data = $self->gh_api->comments(%params);

    my @gh_comments;
    push @gh_comments, $self->update_repo_comment_from_data($gh_repo, $_)
        for @$comments_data;

    return \@gh_comments;
}

# get the issue/pull number by parsing a url like:
# https://api.github.com/repos/duckduckgo/zeroclickinfo-spice/issues/1977
sub number_from_url {
    my ($self, $string) = @_;
    my $uri  = URI->new($string);
    my $path = $uri->path;
    die unless $path =~ m|/issues/(\d+)$|;
    return $1;
}

sub update_repo_comment_from_data {
    my ($self, $gh_repo, $comment) = @_;

    my %columns;
    $columns{github_id}      = $comment->{id};
    $columns{github_user_id} = $self->find_or_update_user($comment->{user}->{login})->id;
    $columns{number}         = $self->number_from_url($comment->{issue_url});
    $columns{body}           = $comment->{body};
    $columns{created_at}     = parse_datetime($comment->{created_at});
    $columns{updated_at}     = parse_datetime($comment->{updated_at});
    $columns{gh_data}        = $comment;

    return $gh_repo
        ->related_resultset('github_comments')
        ->update_or_create(\%columns, { key => 'github_comment_github_id' });
}

sub update_repo_branches {
    my ($self, $gh_repo) = @_;
    my @branches = $self->gh_api->branches($gh_repo->owner_name,$gh_repo->repo_name);
    my $d = $gh_repo->gh_data;
    $d->{branches} = \@branches;
    $gh_repo->gh_data($d);
    $gh_repo->update;
}

sub update_repo_commits {
    my ($self, $gh_repo) = @_;

    return unless $gh_repo->gh_data->{size} > 48;

    my $latest_commit = $gh_repo
        ->related_resultset('github_commits')
        ->most_recent;

    my %params;
    $params{owner}  = $gh_repo->owner_name;
    $params{repo}   = $gh_repo->repo_name;
    $params{since}  = datetime_str($latest_commit->author_date + $self->one_second)
        if $latest_commit;

    my $commits_data = $self->gh_api->commits(%params);

    my @gh_commits;
    push @gh_commits, $self->update_repo_commit_from_data($gh_repo, $_)
        for @$commits_data;

    return \@gh_commits;
}

sub update_repo_commit_from_data {
    my ($self, $gh_repo, $commit) = @_;

    my %columns;
    $columns{author_date}     = parse_datetime($commit->{commit}->{author}->{date});
    $columns{author_email}    = $commit->{commit}->{author}->{email};
    $columns{author_name}     = $commit->{commit}->{author}->{name};
    $columns{committer_date}  = parse_datetime($commit->{commit}->{committer}->{date});
    $columns{committer_email} = $commit->{commit}->{committer}->{email};
    $columns{committer_name}  = $commit->{commit}->{committer}->{name};
    $columns{sha}             = $commit->{sha};
    $columns{message}         = $commit->{message};
    $columns{gh_data}         = $commit;

    $columns{github_user_id_author} = $self->find_or_update_user($commit->{author}->{login})->id
        if defined $commit->{author};

    $columns{github_user_id_committer} = $self->find_or_update_user($commit->{committer}->{login})->id
        if defined $commit->{committer};

    return $gh_repo
        ->related_resultset('github_commits')
        ->update_or_create(\%columns, { key => 'github_commit_sha_github_repo_id' });
}

sub update_repo_issues {
    my ($self, $gh_repo) = @_;

    my $latest_issue = $gh_repo
        ->related_resultset('github_issues')
        ->most_recent;

    my %params;
    $params{owner}  = $gh_repo->owner_name;
    $params{repo}   = $gh_repo->repo_name;
    $params{filter} = 'all';
    $params{state}  = 'all';
    $params{since}  = datetime_str($latest_issue->updated_at + $self->one_second)
        if $latest_issue;

    my $issues_data = $self->gh_api->issues(%params);

    my @gh_issues;
    push @gh_issues, $self->update_repo_issue_from_data($gh_repo, $_)
        for @$issues_data;

    return \@gh_issues;
}

sub update_repo_issue_from_data {
    my ($self, $gh_repo, $issue) = @_;

    my %columns;
    $columns{github_id}      = $issue->{id};
    $columns{github_user_id} = $self->find_or_update_user($issue->{user}->{login})->id;
    $columns{title}          = $issue->{title};
    $columns{body}           = $issue->{body};
    $columns{state}          = $issue->{state};
    $columns{comments}       = $issue->{comments};
    $columns{number}         = $issue->{number};
    $columns{created_at}     = parse_datetime($issue->{created_at});
    $columns{updated_at}     = parse_datetime($issue->{updated_at});
    $columns{closed_at}      = parse_datetime($issue->{closed_at});
    $columns{gh_data}        = $issue;

    $columns{github_user_id_assignee} = $self->find_or_update_user($issue->{assignee}->{login})->id
        if defined $issue->{assignee};

    return $gh_repo
        ->related_resultset('github_issues')
        ->update_or_create(\%columns, { key => 'github_issue_github_id' });
}

sub update_repo_forks {
    my ($self, $gh_repo) = @_;

    my %params;
    $params{owner}  = $gh_repo->owner_name;
    $params{repo}   = $gh_repo->repo_name;

    my $forks_data = $self->gh_api->forks(%params);

    my @gh_forks;
    push @gh_forks, $self->update_repo_fork_from_data($gh_repo, $_)
        for @$forks_data;

    return \@gh_forks;
}

sub update_repo_fork_from_data {
    my ($self, $gh_repo, $fork) = @_;

    my %columns;
    $columns{github_id}      = $fork->{id};
    $columns{github_user_id} = $self->find_or_update_user($fork->{user}->{login})->id;
    $columns{full_name}      = $fork->{full_name};
    $columns{pushed_at}      = parse_datetime($fork->{pushed_at});
    $columns{created_at}     = parse_datetime($fork->{created_at});
    $columns{updated_at}     = parse_datetime($fork->{updated_at});
    $columns{gh_data}        = $fork;

    return $gh_repo
        ->related_resultset('github_forks')
        ->update_or_create(\%columns, { key => 'github_fork_github_id' });
}

1;
