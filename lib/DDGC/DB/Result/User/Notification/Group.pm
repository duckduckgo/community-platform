package DDGC::DB::Result::User::Notification::Group;
# ABSTRACT: 

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'user_notification_group';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column type => {
	data_type => 'text',
	is_nullable => 0,
};

# Context ContextID SubContext  Target
#-------------------------------------------------
# Y     X     Z     Changed/New Z on Y #X
# Y     X           Changes on Y #X
# Y                 Changes on any Y or Changed/New Y
# Y           Z     New Z on any Y

column context => {
	data_type => 'text',
	is_nullable => 0,
};

column with_context_id => {
	data_type => 'int',
	is_nullable => 0,
};

column group_context => {
	data_type => 'text',
	is_nullable => 1,
};

column sub_context => {
	data_type => 'text',
	is_nullable => 0,
};

column action => {
	data_type => 'text',
	is_nullable => 0,
};

column priority => {
	data_type => 'int',
	is_nullable => 0,
};

column filter_by_language => {
	data_type => 'int',
	is_nullable => 0,
};

column email_has_content => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 1,
};

column data => {
	data_type => 'text',
	is_nullable => 0,
	serializer_class => 'JSON',
	default_value => '{}',
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

has_many 'user_notifications', 'DDGC::DB::Result::User::Notification', 'user_notification_group_id', {
	cascade_delete => 1,
};
has_many 'event_notification_groups', 'DDGC::DB::Result::Event::Notification::Group', 'user_notification_group_id', {
	cascade_delete => 1,
};

__PACKAGE__->indices(
	user_notification_group_context_idx => 'context',
	user_notification_group_with_context_id_idx => 'with_context_id',
	user_notification_group_group_context_idx => 'group_context',
	user_notification_group_sub_context_idx => 'sub_context',
	user_notification_group_action_idx => 'action',
	user_notification_group_priority_idx => 'priority',
	user_notification_group_filter_by_language_idx => 'filter_by_language',
);

unique_constraint(
	user_notification_group_unique_key => [qw/
		type context with_context_id sub_context action
	/]
);

###############################

sub default_types_def {{

	# default key = join(|,context.context_name,context.id)
	# beware: context of the fitting related that is hit by the group type
	# not "the context" of the event itself

	# user replies on a comment
	'replies' => {
		context => 'DDGC::DB::Result::Comment',
		context_id => '*',
		sub_context => 'DDGC::DB::Result::Comment',
		action => 'live',
		priority => 100,
		icon => 'bubble',
	},

	# follow all comments on normal types (thread, idea, userblog)
	'forum_comments' => {
		context => [qw(
			DDGC::DB::Result::Thread
			DDGC::DB::Result::Idea
		)],
		context_id => ['*',''],
		sub_context => 'DDGC::DB::Result::Comment',
		action => 'live',
		icon => 'bubble',
	},

	'company_blog_comments' => {
		context => [qw(
			DDGC::DB::Result::User::Blog
		)],
		context_id => '',
		sub_context => 'DDGC::DB::Result::Comment',
		action => 'live',
		priority => 50,
		filter => sub { $_[0]->company_blog ? 1 : 0 },
		icon => 'comments',
	},

	'company_blogs' => {
		context => [qw(
			DDGC::DB::Result::User::Blog
		)],
		context_id => '',
		sub_context => '',
		action => 'live',
		priority => 50,
		filter => sub { $_[0]->company_blog ? 1 : 0 },
		icon => 'pencil',
	},

	'user_blogs' => {
		context => [qw(
			DDGC::DB::Result::User::Blog
		)],
		context_id => '',
		sub_context => '',
		action => 'live',
		filter => sub { $_[0]->company_blog ? 0 : 1 },
		icon => 'pencil',
	},

	'blog_comments' => {
		context => [qw(
			DDGC::DB::Result::User::Blog
		)],
		context_id => '*',
		sub_context => 'DDGC::DB::Result::Comment',
		action => 'live',
		icon => 'bubble',
	},

	# follow all comments on language related context
	'translation_comments' => {
		context => [qw(
			DDGC::DB::Result::Token::Language
			DDGC::DB::Result::Token::Domain::Language
		)],
		context_id => '',
		sub_context => 'DDGC::DB::Result::Comment',
		action => 'live',
		filter_by_language => 1,
		icon => 'comments',
	},

	# follow ideas
	'ideas' => {
		context => 'DDGC::DB::Result::Idea',
		context_id => '',
		sub_context => '',
		action => 'live',
		icon => 'lightbulb',
	},

	# follow ideas
	'idea_updates' => {
		context => 'DDGC::DB::Result::Idea',
		context_id => ['*',''],
		sub_context => '',
		action => 'update',
		icon => 'lightbulb',
		email_has_content => 0,
	},

	# follow idea votes
	'idea_votes' => {
		context => 'DDGC::DB::Result::Idea',
		context_id => ['*',''],
		sub_context => 'DDGC::DB::Result::Idea::Vote',
		action => 'create',
		icon => 'check-sign',
		email_has_content => 0,
	},

	# follow threads
	'threads' => {
		context => 'DDGC::DB::Result::Thread',
		context_id => '',
		sub_context => '',
		action => 'live',
		icon => 'bubbles',
	},

	# follow tokens
	'tokens' => {
		context => 'DDGC::DB::Result::Token',
		context_id => '',
		sub_context => '',
		action => 'create',
		icon => 'globe',
		group_context => 'DDGC::DB::Result::Token::Domain',
		group_context_id => sub { $_[0]->token_domain->id },
	},

	# follow translations
	'translations' => {
		context => 'DDGC::DB::Result::Token::Language::Translation',
		context_id => '',
		sub_context => '',
		action => 'create',
		filter_by_language => 1,
		group_context => 'DDGC::DB::Result::Token::Domain::Language',
		group_context_id => sub { $_[0]->token_language->token_domain_language->id },
		icon => 'globe',
		email_has_content => 0,
	},

	# follow votes on translations
	'translation_votes' => {
		context => 'DDGC::DB::Result::Token::Language::Translation',
		context_id => '*',
		sub_context => 'DDGC::DB::Result::Token::Language::Translation::Vote',
		action => 'create',
		icon => 'check-sign',
		email_has_content => 0,
	},

	'moderations' => {
		context => [qw(
			DDGC::DB::Result::Comment
			DDGC::DB::Result::Idea
			DDGC::DB::Result::Thread
		)],
		context_id => '',
		sub_context => '',
		action => 'create',
		icon => 'globe',
		u => sub { ['Forum::Admin','moderations'] },
		group_context => '',
		group_context_id => sub { 1 },
		filter => sub { (
			$_[0]->ghosted && !$_[0]->user->ignore && $_[1]->is('forum_manager')
		) ? 1 : 0 },
	},

	'reports' => {
		context => [qw(
			DDGC::DB::Result::User::Report
		)],
		context_id => '',
		sub_context => '',
		action => 'create',
		icon => 'globe',
		u => sub { ['Forum::Admin','reports'] },
		group_context => '',
		group_context_id => sub { 1 },
		filter => sub { (
			!$_[0]->user->ignore && $_[1]->is('forum_manager')
		) ? 1 : 0 },
	},

}}

sub filter {
	my ( $self ) = @_;
	return $self->default_types_def->{$self->type}->{filter};
}

sub group_context_id {
	my ( $self ) = @_;
	return $self->default_types_def->{$self->type}->{group_context_id};
}

sub u {
	my ( $self ) = @_;
	return $self->default_types_def->{$self->type}->{u};
}

sub icon {
	my ( $self ) = @_;
	return defined $self->default_types_def->{$self->type}->{icon}
		? $self->default_types_def->{$self->type}->{icon}
		: 'default';
}

sub default_types {
	my ( $self ) = @_;

	my @types;

	for my $type (keys %{$self->default_types_def}) {
		my %def = %{$self->default_types_def->{$type}};
		my @contexts = ref $def{context} eq 'ARRAY'
			? (@{$def{context}})
			: ($def{context});
		for my $context (@contexts) {
			my @context_ids = ref $def{context_id} eq 'ARRAY'
			? (@{$def{context_id}})
			: ($def{context_id});
			for my $context_id (@context_ids) {
				my $with_context_id = $context_id eq '*' ? 1 : 0;
				push @types, {
					type => $type,
					context => $context,
					group_context => defined $def{group_context}
						? $def{group_context}
						: $context,
					sub_context => $def{sub_context},
					with_context_id => $with_context_id,
					action => $def{action},
					filter_by_language => $def{filter_by_language} ? 1 : 0,
					priority => $def{priority}
						? $def{priority}
						: $with_context_id
							? 0
							: 1,
					defined $def{email_has_content}
						? ( email_has_content => $def{email_has_content} )
						: (),
				};
			}
		}
	}

	return @types;

}

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
