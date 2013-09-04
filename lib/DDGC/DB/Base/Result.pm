package DDGC::DB::Base::Result;
# ABSTRACT: Base class for all DBIx::Class Result base classes of the project

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::Core';
use namespace::autoclean;

__PACKAGE__->load_components(qw/
    TimeStamp
    InflateColumn::DateTime
    InflateColumn::Serializer
    EncodedColumn
/);

sub context_config {{
	'DDGC::DB::Result::Comment' => {
		relation => 'comment',
		prefetch => [qw( user )],
	},
	'DDGC::DB::Result::Event' => {
		relation => 'event',	
	},
	'DDGC::DB::Result::Thread' => {
		relation => 'thread',
		prefetch => [qw( user comment )],
	},
	'DDGC::DB::Result::Token' => {
		relation => 'token',
		prefetch => [qw( token_domain )],
	},
	'DDGC::DB::Result::Token::Language' => {
		relation => 'token_language',
		prefetch => [{
      token => [qw( token_domain )],
      token_domain_language => [qw( token_domain language )],
      token_language_translations => [qw( user )]
    }],
	},
	'DDGC::DB::Result::Token::Domain::Language' => {
		relation => 'token_domain_language',
		prefetch => [qw( token_domain language )],
	},
	'DDGC::DB::Result::User::Blog' => {
		relation => 'user_blog',
		prefetch => [qw( user )],
	},
	'DDGC::DB::Result::Token::Language::Translation::Vote' => {
		relation => 'token_language_translation_vote',
		prefetch => [qw( user ),{
			token_language_translation => [qw( user ),{
				token_language => {
		      token => [qw( token_domain )],
		      token_domain_language => [qw( token_domain language )],
		    }
			}]
		}],
	},
}}

sub add_context_relations {
  my ( $class ) = @_;
  die $class." doesnt have context and context_id"
  	unless $class->can('context') && $class->can('context_id');
  for my $context_class (sort { $a cmp $b } keys %{$class->context_config}) {
  	next if $context_class eq $class;
  	my $config = $class->context_config->{$context_class};
	  $class->belongs_to($config->{relation}, $context_class, sub {{
	    "$_[0]->{foreign_alias}.id" => { -ident => "$_[0]->{self_alias}.context_id" },
	    "$_[0]->{self_alias}.context" => $context_class,
	  }}, {
	    join_type => 'left',
	    on_delete => 'no action',
	  });
  }
}

sub default_result_namespace { 'DDGC::DB::Result' }

sub ddgc { shift->result_source->schema->ddgc }
sub schema { shift->result_source->schema }

sub add_event {
	my ( $self, $action, %args ) = @_;
	my %event;
	$event{context} = ref $self;
	$event{context_id} = $self->id;
	my $users_id;
	if ($self->can('users_id')) {
		$users_id = $self->users_id;
	} elsif ($self->can('user')) {
		$users_id = $self->user->id
	}
	$users_id = delete $args{users_id} if defined $args{users_id};
	if ($users_id) {
		$event{users_id} = $users_id;
	}
	$event{action} = $action;
	if ($self->can('event_related')) {
		$event{related} = [$self->event_related, defined $args{related} ? @{delete $args{related}} : ()];
	}
	if ($args{related}) {
		$event{related} = [] unless defined $event{related};
		my $related = delete $args{related};
		push @{$event{related}}, @{$related};
	}
	$event{data} = \%args if %args;
	$self->ddgc->db->txn_do(sub {
		my $event_result = $self->result_source->schema->resultset('Event')->create({ %event });
		for (@{$event{related}}) {
			$event_result->create_related('event_relates',{
				context => $_->[0],
				context_id => $_->[1],
			});
		}
	});
}

sub has_context {
	my ( $self ) = @_;
	return $self->does('DDGC::DB::Role::HasContext');
}

sub all_comments {
	my ( $self ) = @_;
	return $self->schema->resultset('Comment')->search_rs({
		'me.context' => $self->i_context,
		'me.context_id' => $self->i_context_id,
	},{
		order_by => { -desc => [qw( me.updated )] },
	});
}

sub comments {
	my ( $self ) = @_;
	return $self->schema->resultset('Comment')->search_rs({
		'me.context' => $self->i_context,
		'me.context_id' => $self->i_context_id,
		'me.parent_id' => undef,
	},{
		order_by => { -desc => [qw( me.updated )] },
	})->prefetch_tree;
}

sub i_context {
	my ( $self ) = @_;
	my $ref = ref $self;
	return $ref;
}

sub i_context_id {
	my ( $self ) = @_;
	return $self->id;
}

sub belongs_to {
	my ($self, @args) = @_;

	$args[3] = {
		is_foreign => 1,
		on_update => 'cascade',
		on_delete => 'restrict',
		%{$args[3]||{}}
	};

	$self->next::method(@args);
}

use overload '""' => sub {
	my $self = shift;
	return (ref $self).' #'.$self->id;
}, fallback => 1;

no Moose;
__PACKAGE__->meta->make_immutable;
