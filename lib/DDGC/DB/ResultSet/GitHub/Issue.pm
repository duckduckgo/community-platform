package DDGC::DB::ResultSet::GitHub::Issue;
# ABSTRACT: Resultset class for GitHub Issues

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;

sub most_recent {
    my ($self) = @_;
    return $self->search(
        {},
        {
            rows => 1,
            order_by => { -desc => 'updated_at' },
        }
    )->first;
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
