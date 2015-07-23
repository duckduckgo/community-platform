package DDGC::Web::Controller::Admin;
# ABSTRACT:

use Moose;
use namespace::autoclean;

use DDGC::Config;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('admin') :CaptureArgs(0) {
    my ( $self, $c ) = @_;
	if (!$c->user) {
		$c->response->redirect($c->chained_uri('My','login',{ admin_required => 1 }));
		return $c->detach;
	}


	if (!$c->user->admin) {
		$c->response->redirect($c->chained_uri('Root','index',{ admin_required => 1 }));
		return $c->detach;
	}
	$c->stash->{title} = 'Admin area';
	$c->add_bc('Admin area', $c->chained_uri('Admin','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
    my ( $self, $c ) = @_;
	$c->bc_index;
	$c->stash->{latest_updated_users} = [ $c->d->rs('User')->search({},{
		order_by => { -desc => 'me.updated' },
		rows => 5,
		page => 1,
	})->all ];
	$c->stash->{day_registrations_count} = $c->d->rs('User')->search({
		created => { ">" => $c->d->db->storage->datetime_parser->format_datetime(
			DateTime->now - DateTime::Duration->new( days => 1 )
		) },
	},{})->count;
	$c->stash->{languages_count} = $c->d->rs('Language')->count;
	$c->stash->{countries_count} = $c->d->rs('Country')->count;
	$c->stash->{translations_count} = $c->d->rs('Token::Language::Translation')->count;
	$c->stash->{votes_count} = $c->d->rs('Token::Language::Translation::Vote')->count;
	$c->stash->{token_domains_count} = $c->d->rs('Token::Domain')->count;
	$c->stash->{tokens_count} = $c->d->rs('Token')->count;
	$c->stash->{remaining_coupon_count} = $c->d->rs('User::Coupon')->search({ users_id => undef })->count;
}

no Moose;
__PACKAGE__->meta->make_immutable;
