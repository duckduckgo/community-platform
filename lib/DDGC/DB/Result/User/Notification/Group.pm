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

has_many 'user_notifications', 'DDGC::DB::Result::User::Notification', 'users_id';

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
    action => 'create',
    priority => 100,
  },

  # follow all comments on normal types (thread, idea, userblog)
  'forum_comments' => {
    context => [qw(
      DDGC::DB::Result::Thread
      DDGC::DB::Result::Idea
    )],
    context_id => ['*',''],
    sub_context => 'DDGC::DB::Result::Comment',
    action => 'create',
  },

  'company_blog_comments' => {
    context => [qw(
      DDGC::DB::Result::User::Blog
    )],
    context_id => '',
    sub_context => 'DDGC::DB::Result::Comment',
    action => 'create',
    priority => 50,
  },

  'company_blogs' => {
    context => [qw(
      DDGC::DB::Result::User::Blog
    )],
    context_id => '',
    sub_context => '',
    action => 'create',
  },

  'blog_comments' => {
    context => [qw(
      DDGC::DB::Result::User::Blog
    )],
    context_id => '*',
    sub_context => 'DDGC::DB::Result::Comment',
    action => 'create',
  },

  # follow all comments on language related context
  'translation_comments' => {
    context => [qw(
      DDGC::DB::Result::Token::Language
      DDGC::DB::Result::Token::Domain::Language
    )],
    context_id => '',
    sub_context => 'DDGC::DB::Result::Comment',
    action => 'create',
    filter_by_language => 1,
  },

  # follow ideas
  'ideas' => {
    context => 'DDGC::DB::Result::Idea',
    context_id => '',
    sub_context => '',
    action => 'create',
  },

  # follow ideas
  'idea_updates' => {
    context => 'DDGC::DB::Result::Idea',
    context_id => ['*',''],
    sub_context => '',
    action => 'update',
  },

  # follow idea votes
  'idea_votes' => {
    context => 'DDGC::DB::Result::Idea',
    context_id => ['*',''],
    sub_context => 'DDGC::DB::Result::Idea::Vote',
    action => 'create',
  },

  # follow threads
  'threads' => {
    context => 'DDGC::DB::Result::Thread',
    context_id => '',
    sub_context => '',
    action => 'create',
  },

  # follow tokens
  'tokens' => {
    context => 'DDGC::DB::Result::Token',
    context_id => '',
    sub_context => '',
    action => 'create',
  },

  # follow translations
  'translations' => {
    context => 'DDGC::DB::Result::Token::Language::Translation',
    context_id => '',
    sub_context => '',
    action => 'create',
    filter_by_language => 1,
  },

  # follow votes on translations
  'translation_votes' => {
    context => 'DDGC::DB::Result::Token::Language::Translation',
    context_id => '*',
    sub_context => 'DDGC::DB::Result::Token::Language::Translation::Vote',
    action => 'create',
  },

}}

sub company_blogs_where {{
  company_blog => 1
}}

sub company_blog_comments_where {{
  company_blog => 1
}}

sub translations_key {
  my ( $self, $context ) = @_;
  join('|','translations','DDGC::DB::Result::Token::Domain::Language',$_[0]->token_language->token_domain_language->id)  
}

sub translations_u {
  my ( $self, $context, $sub_context ) = @_;
  $context->token_language->u;
}

sub translation_votes_key {
  my ( $self, $context, $sub_context ) = @_;
  join('|','translation_votes','DDGC::DB::Result::Token::Language',$context->token_language->id);
}

sub translation_votes_u {
  my ( $self, $context, $sub_context ) = @_;
  $context->token_language->token_domain_language->u_unvoted;
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
          sub_context => $def{sub_context},
          with_context_id => $with_context_id,
          action => $def{action},
          filter_by_language => $def{filter_by_language} ? 1 : 0,
          priority => $def{priority}
            ? $def{priority}
            : $with_context_id
              ? 0
              : 1,
        };
      }
    }
  }

  return @types;

}

no Moose;
__PACKAGE__->meta->make_immutable;
