package DDGC::DB::ResultSet::InstantAnswer;
# ABSTRACT: Resultset class for Instant Answer Pages

use Moose;
extends 'DDGC::DB::Base::ResultSet';
use namespace::autoclean;
use DateTime::Format::Pg;

sub last_modified {
    my ( $self ) = @_;
    DateTime::Format::Pg->parse_datetime(
        $self->search( {}, {
            columns => [
                { last_modified => { max => 'updated' } },
            ],
        } )->one_row->get_column('last_modified')
    );
}

1;
