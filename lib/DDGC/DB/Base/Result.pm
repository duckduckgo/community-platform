package DDGC::DB::Base::Result;
# ABSTRACT: Base class for all DBIx::Class Result base classes of the project

use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::Core';
use namespace::autoclean;

use Moose::Util qw/ apply_all_roles /;

__PACKAGE__->load_components(qw/
    TimeStamp
    InflateColumn::DateTime
    InflateColumn::Serializer
    EncodedColumn
    Helper::Row::OnColumnChange
    Helper::Row::ProxyResultSetMethod
    +DBICx::Indexing
/);

sub context_config {
	my ( $class, %opts ) = @_;

{
	'DDGC::DB::Result::Comment' => {
		relation => 'comment',
		prefetch => [qw( user parent ),(
			$opts{comment_prefetch}
				? ($opts{comment_prefetch})
				: ()
		)],
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
}

}

sub add_context_relations {
  my ( $class ) = @_;
  $class->add_context_relations_column;
  $class->add_context_relations_role;
  $class->add_context_relations_belongs_to;
}

sub add_context_relations_column {
	my ( $class ) = @_;
	$class->add_column(context => {
		data_type => 'text',
		is_nullable => 0,
	});
	$class->add_column(context_id => {
		data_type => 'bigint',
		is_nullable => 0,
	});
}

sub add_context_relations_role {
	my ( $class ) = @_;
  apply_all_roles($class,'DDGC::DB::Role::HasContext');
}

sub add_context_relations_belongs_to {
	my ( $class ) = @_;
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

sub add_antispam_functionality {
	my ( $class ) = @_;
	$class->add_column(ghosted => {
		data_type => 'int',
		default_value => 1,
		keep_storage_value => 1,
	});
	$class->add_column(checked => {
		data_type => 'bigint',
		is_nullable => 1,
		keep_storage_value => 1,
	});
	$class->add_column(seen_live => {
		data_type => 'int',
		default_value => 0,
		keep_storage_value => 1,
	});
  apply_all_roles($class,'DDGC::DB::Role::AntiSpam');
  my $resultset_class = $class;
  $resultset_class =~ s/::Result::/::ResultSet::/g;
  apply_all_roles($resultset_class,'DDGC::DB::Role::AntiSpamResultSet');
	$class->after_column_change( ghosted => {
		method   => 'ghosted_changed',
		txn_wrap => 1,
	});
}

sub default_result_namespace { 'DDGC::DB::Result' }

sub schema { $_[0]->result_source->schema }
sub ddgc { $_[0]->schema->ddgc }
sub ddgc_config { $_[0]->schema->ddgc_config; }
sub app { $_[0]->schema->app; }

sub add_event {
	my ( $self, $action, %args ) = @_;
	return if $self->schema->no_events;
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
	my @related = defined $event{related}
		? (@{delete $event{related}})
		: ();
	$event{data} = \%args if %args;
	$self->ddgc->db->txn_do(sub {
		my $event_result = $self->result_source->schema->resultset('Event')->create({ %event });
		for (@related) {
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
	return $self->schema->resultset('Comment')->ghostbusted->search_rs({
		'me.context' => $self->i_context,
		'me.context_id' => $self->i_context_id,
	},{
		order_by => { -desc => [qw( me.updated )] },
	});
}

sub comments {
	my ( $self ) = @_;
	return $self->schema->resultset('Comment')->ghostbusted->search_rs({
		'me.context' => $self->i_context,
		'me.context_id' => $self->i_context_id,
		'me.parent_id' => undef,
	},{
		order_by => { -desc => [qw( me.updated )] },
	})->prefetch_tree;
}

sub context_name {
	my ( $self ) = @_;
	my $ref = ref $self;
	return $ref;
}

sub i_context { shift->context_name(@_) }

sub i_context_id {
	my ( $self ) = @_;
	return $self->id;
}

sub i_param { $_[0]->i_context.'|'.$_[0]->i_context_id }

sub i_related {[
	$_[0]->i_context,
	$_[0]->i_context_id,
]}

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

sub delete {
	my ( $self, @args ) = @_;

	my $context = $self->context_name;
	my $context_id = $self->id;

	my $result = $self->next::method(@args);

	$self->schema->resultset('Event')->search([{
		'me.context' => $context,
		'me.context_id' => $context_id,
	},{
		'event_relates.context' => $context,
		'event_relates.context_id' => $context_id,
	}],{
		join => [qw( event_relates )],
	})->delete;

	$self->schema->resultset('Event::Relate')->search({
		context => $context,
		context_id => $context_id,
	})->delete;

	$self->schema->resultset('Comment')->search({
		context => $context,
		context_id => $context_id,
	})->delete;

	return $result;
}

use overload '""' => sub {
	my $self = shift;
	return (ref $self).' #'.$self->id;
}, fallback => 1;

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
