package DDGC::DB::ResultSet::User;
# ABSTRACT: Resultset class for user

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub find_by_github_login {
    my ( $self, $login ) = @_;
    my $stats_user = $self->schema->resultset('GitHub::User')->find({
        login => $login
    });
    return ( $stats_user )
        ? $stats_user->user
        : $self->find({ github_user_plaintext => $login });
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
