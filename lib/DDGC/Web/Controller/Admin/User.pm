package DDGC::Web::Controller::Admin::User;
# ABSTRACT: User administration web controller class

use Moose;
use namespace::autoclean;

use DDGC::Config;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/admin/base') :PathPart('user') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
    my @search_attrs;
    $c->stash->{user_search} = $c->req->param('user_search');
    if ($c->stash->{user_search}) {
    	my @user_search_fields;
    	for (qw( username data notes )) {
    		push @user_search_fields, $_, { -like => '%'.$c->stash->{user_search}.'%' };
    	}
    	push @search_attrs, -or => [
    		@user_search_fields
    	];
    }
    $c->pager_init($c->action.$c->stash->{user_search},20);
    $c->stash->{page} = 1 if $c->req->param('user_search_submit');
	$c->stash->{users} = $c->d->rs('User')->search({
		@search_attrs
	},{
		order_by => 'me.created',
		page => $c->stash->{page},
		rows => $c->stash->{pagesize},
	});
	$c->stash->{users_count} = $c->stash->{users}->count;
}

__PACKAGE__->meta->make_immutable;

1;
