package DDGC::Web::Controller::My::GitHub;
# ABSTRACT: Web controller for github interactions

use Moose;
use DDGC::GitHub::Plugin;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/my/logged_in') :PathPart('github') :CaptureArgs(0) {
	return;
	my ( $self, $c ) = @_;
	$c->require_action_token;
	$c->stash->{title} = 'GitHub';
	$c->add_bc($c->stash->{title}, '');
	$c->stash->{github_client_id} = $c->d->config->github_client_id;
	if ($c->req->params->{code}) {
		my $github_user = $c->d->github->validate_session_code($c->req->params->{code},$c->user);
		if ($github_user) {
			$c->user->search_related('github_users',{
				id => { '!=' => $github_user->id },
			})->update({ users_id => 0 });
		}
	}
	$c->stash->{github_user} = $c->user->github_user;
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ($self, $c) = @_;
	$c->stash->{repos} = $c->stash->{github_user}->search_related('github_repos',{
	    company_repo => 1,
	}) if defined $c->stash->{github_user};
	
	if ($c->req->params->{update_repos} && $c->user->admin) {
	    return unless defined $c->stash->{github_user};
	    $c->d->github->update_repos($c->stash->{github_user}->login, 0);
	}
}

sub pull_request :Chained('base') :Args(1) {
    my ($self, $c, $repo) = @_;

    $c->stash->{repo} = $c->d->rs('GitHub::Repo')->find({full_name => $c->user->github_user->login.'/'.$repo});
    my $plugin = DDGC::GitHub::Plugin->new;
    $plugin->field('branch')->params->{options} = [map { $_->{name} => $_->{name} } @{ $c->stash->{repo}->gh_data->{branches} }];
    $plugin->update_data({branch => $c->stash->{repo}->gh_data->{default_branch}});
    $c->stash->{fields} = $plugin->attribute_fields;
    # TODO: Do something useful here!
}

1;
