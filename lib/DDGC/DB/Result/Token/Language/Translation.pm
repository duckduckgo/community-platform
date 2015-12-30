package DDGC::DB::Result::Token::Language::Translation;
# ABSTRACT: A translation

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;

use DateTime;
use Locale::Simple;

use namespace::autoclean;

table 'token_language_translation';

sub u { shift->token_language->u }

sub event_related {
	my ( $self ) = @_;
	my @related = $self->token_language->event_related;
	push @related, ['DDGC::DB::Result::Token::Language', $self->token_language_id];
	return @related;
}

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column msgstr0 => {
	data_type => 'text',
	is_nullable => 0,
};
sub msgstr { shift->msgstr0(@_) }

column msgstr1 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr2 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr3 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr4 => {
	data_type => 'text',
	is_nullable => 1,
};

column msgstr5 => {
	data_type => 'text',
	is_nullable => 1,
};

sub msgstr_index_max { 5 }

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
};

column token_language_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column check_result => {
	data_type => 'int',
	is_nullable => 1,
};

column check_timestamp => {
	data_type => 'timestamp with time zone',
	is_nullable => 1,
};
sub checked { shift->check_timestamp ? 1 : 0 }

column check_users_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

sub invalid {
	my ( $self ) = @_;
	return ( $self->checked && !$self->check_result )
		? 1
		: 0;
}

#column users_id => {
#	data_type => 'bigint',
#	is_nullable => 1,
#};

column username => {
	data_type => 'text',
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

#belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'user', 'DDGC::DB::Result::User', { 'foreign.username' => 'self.username' };
belongs_to 'check_user', 'DDGC::DB::Result::User', 'check_users_id', { join_type => 'left' };

belongs_to 'token_language', 'DDGC::DB::Result::Token::Language', 'token_language_id', {
	on_delete => 'cascade',
};

has_many 'token_language_translation_votes', 'DDGC::DB::Result::Token::Language::Translation::Vote', 'token_language_translation_id', {
	cascade_delete => 1,
};
sub votes { shift->token_language_translation_votes(@_) }

before insert => sub {
	my ( $self ) = @_;
	$self->sprintf_check;
};

after insert => sub {
  my ( $self ) = @_;
  $self->add_event('create');
  $self->user->add_context_notification('translation_votes',$self);
};

sub user_voted {
	my ( $self, $user ) = @_;
	my $result = $self->search_related('token_language_translation_votes',{
		users_id => $user->db->id,
	})->all;
}

sub force_check {
	my ( $self ) = @_;
	$self->sprintf_check;
	$self->update;
}

sub sprintf_check {
	my ( $self ) = @_;
	return if $self->check_users_id;
	my $msgid = $self->token_language->token->msgid;
	$self->check_timestamp(DateTime->now);
	$self->check_result(Locale::Simple::sprintf_compare(
		$msgid,
		$self->msgstr0
	) ? 1 : 0);
	my $msgid_plural = $self->token_language->token->msgid_plural;
	if ($msgid_plural) {
		for my $keyno (1..$self->msgstr_index_max) {
			my $key = 'msgstr'.$keyno;
			next unless $self->$key;
			$self->check_result(Locale::Simple::sprintf_compare(
				$msgid_plural,
				$self->$key
			) ? 1 : 0);
		}
	}
}

sub vote_count {
	my ( $self ) = @_;
	$self->token_language_translation_votes->count;
}

sub set_check {
	my ( $self, $user, $check ) = @_;
	if ($user->translation_manager) {
		$self->check_result($check ? 1 : 0);
		$self->check_users_id($user->id);
		$self->check_timestamp(DateTime->now);
	} else {
		die "you are not a translation manager, you cant check the translation!";
	}
}

sub set_user_vote {
	my ( $self, $user, $vote ) = @_;
	return if $user->id == $self->user->id;
	return unless $user->can_speak($self->token_language->token_domain_language->language->locale);
	if ($vote) {
		my $voted = $self->search_related('token_language_translation_votes',{
			users_id => $user->db->id,
		})->one_row;
		unless ($voted) {
			$self->create_related('token_language_translation_votes',{
				users_id => $user->db->id,
			});
		}
	} else {
		$self->search_related('token_language_translation_votes',{
			users_id => $user->db->id,
		})->delete;
	}
}

sub key {
	my ( $self ) = @_;
	my $key;
	for (0..$self->msgstr_index_max) {
		my $func = 'msgstr'.$_;
		$key .= $self->$func ? $self->$func : '';
	}
	return $key;
}



no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
