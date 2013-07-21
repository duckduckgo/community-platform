package DDGC::Web::Controller::Admin::User;
# ABSTRACT: User administration web controller class

use Moose;
BEGIN { extends 'Catalyst::Controller'; }

use namespace::autoclean;

sub base :Chained('/admin/base') :PathPart('user') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('User management', $c->chained_uri('Admin::User','index'));
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;

	my $rs = $c->d->rs('User')->search({},{
		order_by => 'me.created',
	});

	$c->stash->{user_table} = $c->table($rs,['Admin::User','index'],[
			Username => 'username',
			Email => sub { $_->data && $_->data->{email} },
			'Has Userpage' => sub {
				( $_->userpage || ( $_->data && $_->data->{userpage} ) )
					? 'Yes' : 'No'
			},
			'Languages' => sub { $_->user_languages->count },
			'Pic' => {
				i => 'userpic',
				i_args => { userpic_size => 16 },
			},
		],
		default_pagesize => 10,
		u_row => sub { [ 'Admin::User','user',$_->username ] },
	);
}

sub user_base :Chained('base') :PathPart('view') :CaptureArgs(1) {
    my ( $self, $c, $username ) = @_;
    $c->stash->{user} = $c->d->find_user($username);
    unless ($c->stash->{user}) {
        $c->response->redirect($c->chained_uri('Admin::User','index',{ user_not_found => 1 }));
        return $c->detach;
    }
}

sub user :Chained('user_base') :PathPart('') :Args(0) {}

no Moose;
__PACKAGE__->meta->make_immutable;
