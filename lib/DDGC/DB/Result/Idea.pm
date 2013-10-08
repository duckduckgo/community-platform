package DDGC::DB::Result::Idea;
# ABSTRACT: DuckDuckHack Instant Answer Plugin

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::Human::Duration;
use namespace::autoclean;

table 'idea';

sub u { [ 'Ideas', 'idea', $_[0]->id, $_[0]->key ] }

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column key => {
  data_type => 'text',
  is_nullable => 0,
  indexed => 1,
};

column title => {
  data_type => 'text',
  is_nullable => 0,
};

column content => {
  data_type => 'text',
  is_nullable => 0,
};
sub html { $_[0]->ddgc->markup->html($_[0]->content) }

column source => {
  data_type => 'text',
  is_nullable => 1,
};
sub source_html { $_[0]->source ? $_[0]->ddgc->markup->html($_[0]->source) : "" }

column data => {
  data_type => 'text',
  is_nullable => 1,
  serializer_class => 'JSON',
};

sub types {{
  0 => "I don't know...",
  1 => "Fathead (keyword data)",
  2 => "Goodie (Perl functions)",
  3 => "Spice (API calls)",
  4 => "Longtail (full-text data)",
  5 => "Internal",
}}

sub type_name { $_[0]->types->{$_[0]->type} }

column type => {
  data_type => 'int',
  default_value => 0,
};

sub statuses {{
  0 => "New",
  1 => "Needs More Definition",
  2 => "Needs Source Suggestions",
  3 => "Needs a Developer",
  4 => "In Development",
  5 => "Under Review",
  6 => "On Hold",
  7 => "Duplicate",
  8 => "Live",
  9 => "Not an Instant Answer idea",
  10 => "Improvement",
  11 => "Declined",
}}

sub status_name { $_[0]->statuses->{$_[0]->status} }

sub status_colors {{
  1 => "#000000",
  2 => "#f06f05",
  3 => "#f50505",
  4 => "#0865d6",
  5 => "#999999",
  6 => "#48ff00",
  7 => "#13f5e2",
  8 => "#30a800",
  9 => "#f0e405",
  10 => "#a100a1",
  11 => "#bbbbbb",
}}

sub status_color { $_[0]->status_colors->{$_[0]->status} }

column status => {
  data_type => 'int',
  default_value => 0,
};

column old_vote_count => {
  data_type => 'int',
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

column old_url => {
	data_type => 'text',
	is_nullable => 1,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';

has_many 'idea_votes', 'DDGC::DB::Result::Idea::Vote', 'idea_id', {
  cascade_delete => 1,
};

sub vote_count {
  my ( $self ) = @_;
  return $self->old_vote_count + $self->idea_votes->count
}

sub user_voted {
  my ( $self, $user ) = @_;
  return $self->search_related('idea_votes',{
    users_id => $user->db->id,
  })->count;
}

after insert => sub {
  my ( $self ) = @_;
  $self->add_event('create');
};

after update => sub {
  my ( $self ) = @_;
  $self->add_event('update');
};

before insert => sub {
  my ( $self ) = @_;
  unless ($self->key) {
    $self->key($self->get_url);
  }
};

sub set_user_vote {
  my ( $self, $user, $vote ) = @_;
  return if $user->id == $self->user->id;
  if ($vote) {
    $self->update_or_create_related('idea_votes',{
      users_id => $user->db->id,
    },{
      key => 'idea_users',
    });
  } else {
    $self->search_related('idea_votes',{
      users_id => $user->db->id,
    })->delete;
  }
}

sub get_url {
  my $self = shift;
  my $key = substr(lc($self->title),0,50);
  $key =~ s/[^a-z0-9]+/-/g;
  $key =~ s/-+/-/g;
  $key =~ s/-$//;
  $key =~ s/^-//;
  return $key;
}

no Moose;
__PACKAGE__->meta->make_immutable;
