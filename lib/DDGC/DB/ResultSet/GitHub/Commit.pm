package DDGC::DB::ResultSet::GitHub::Commit;
# ABSTRACT: Resultset class for GitHub Commits

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub with_author_date {
    my ($self, $operator, $date) = @_;
	$self->search({ author_date => { $operator => $date } });
}

# ignore users who are members of the owners team on github.  these users are
# usually ddg employees:
# https://github.com/orgs/duckduckgo/teams/owners
sub with_no_owners {
	shift->search({ author_login => { -not_in => [qw//]} });
}

sub with_state { 
    my ($self, $state) = @_;
    $self->search({ state => $state }) ;
}

sub most_recent {
    my ($self) = @_;
    return $self->search(
        {},
        {
            rows => 1,
            order_by => { -desc => 'author_date' },
        }
    )->first;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
