package DDGC::DB::Result::User::Report;
# ABSTRACT: User report for content

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'user_report';

sub u { 
  my ( $self ) = @_;
  if ( my $context_obj = $self->get_context_obj ) {
    if ($context_obj->can('u_report')) {
      my $u = $context_obj->u_report;
      return $u if $u;
    }
    if ($context_obj->can('u')) {
      my $u = $context_obj->u;
      return $u if $u;
    }
  }
  return;
}

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
  data_type => 'bigint',
  is_nullable => 1,
};

__PACKAGE__->add_context_relations;

# 0: free text
# 1: Link bait
# 2: Harassment
# 3: Bad language
# 4: Off topic
# 5: Content farming
column type => {
  data_type => 'int',
  is_nullable => 1,
  default_value => 0,
};

column text => {
  data_type => 'text',
  is_nullable => 1,
  default_value => '',
};

column data => {
  data_type => 'text',
  is_nullable => 0,
  serializer_class => 'JSON',
  default_value => '{}',
};

column checked => {
  data_type => 'bigint',
  is_nullable => 1,
};

column ignore => {
  data_type => 'int',
  is_nullable => 0,
  default_value => 0,
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

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id', {
  on_delete => 'no action',
};

belongs_to 'user_checked', 'DDGC::DB::Result::User', 'checked', {
  on_delete => 'no action',
};

before insert => sub {
  my ( $self ) = @_;
  if ($self->user->ignore) {
    $self->ignore(1);
  }
};

after insert => sub {
  my ( $self ) = @_;
  $self->add_event('create');
};

sub event_related {
  my ( $self ) = @_;
  my @related;
  if ( $self->context_resultset ) {
    push @related, [$self->context, $self->context_id];
  }
  return @related;
}

###############################

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );

1;
