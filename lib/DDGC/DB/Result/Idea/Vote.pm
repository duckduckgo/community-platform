package DDGC::DB::Result::Idea::Vote;
# ABSTRACT: A vote of a user on an Instant Answer idea

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'idea_vote';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column idea_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column created => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
};

column updated => {
  data_type => 'timestamp with time zone',
  set_on_create => 1,
  set_on_update => 1,
};

unique_constraint(
  idea_users => [qw/ idea_id users_id /]
);

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', {
  on_delete => 'cascade',
};
belongs_to 'idea', 'DDGC::DB::Result::Idea', 'idea_id', {
  on_delete => 'cascade',
};

after insert => sub {
  my ( $self ) = @_;
  $self->add_event('create');
};

sub event_related {
  my ( $self ) = @_;
  my @related;
  push @related, ['DDGC::DB::Result::Idea', $self->idea_id];
  return @related;
}

no Moose;
__PACKAGE__->meta->make_immutable;
