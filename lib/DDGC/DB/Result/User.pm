package DDGC::DB::Result::User;

use DBIx::Class::Candy -components => [ 'TimeStamp', 'InflateColumn::DateTime', 'InflateColumn::Serializer', 'EncodedColumn', 'AlwaysUpdate' ];
use Moose;

table 'users';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

unique_column username => {
	data_type => 'text',
	is_nullable => 0,
};

column public => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
};

column admin => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column notes => {
	data_type => 'text',
	is_nullable => 1,
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

column roles => {
	data_type => 'text',
	is_nullable => 1,
	default_value => '',
};

# WORKAROUND
sub db { return shift; }

sub translation_manager { shift->is('translation_manager') }

sub is {
	my ( $self, $role ) = @_;
	return 0 if !$role;
	return 1 if $self->admin;
	return 1 if $self->roles =~ m/$role/;
	return 0;
}

has _locale_user_languages => (
	isa => 'HashRef[DDGC::DB::Result::User::Language]',
	is => 'ro',
	lazy_build => 1,
);
sub lul { shift->_locale_user_languages }

sub can_speak {
	my ( $self, $locale ) = @_;
	return defined $self->lul->{$locale};
}

sub _build__locale_user_languages {
	my ( $self ) = @_;
	my @user_languages = $self->user_languages;
	my %lul;
	for (@user_languages) {
		$lul{$_->language->locale} = $_;
	}
	return \%lul;
}

has_many 'screens', 'DDGC::DB::Result::Screen', { 'foreign.username' => 'self.username' };
has_many 'token_language_translations', 'DDGC::DB::Result::Token::Language::Translation', { 'foreign.username' => 'self.username' };
has_many 'user_languages', 'DDGC::DB::Result::User::Language', { 'foreign.username' => 'self.username' };
has_many 'token_languages', 'DDGC::DB::Result::Token::Language', 'translator_users_id';
has_many 'checked_translations', 'DDGC::DB::Result::Token::Language::Translation', 'check_users_id';
has_many 'translation_votes', 'DDGC::DB::Result::Token::Language::Translation::Vote', 'users_id';
has_many 'comments', 'DDGC::DB::Result::Comment', 'users_id';
has_many 'duckpan_releases', 'DDGC::DB::Result::DuckPAN::Release', 'users_id';
has_many 'duckpan_permissions', 'DDGC::DB::Result::DuckPAN::Permission', 'users_id';
has_many 'threads', 'DDGC::DB::Result::Thread', 'users_id';

many_to_many 'languages', 'user_languages', 'language';

sub translation_count { shift->token_language_translations->count(@_); }

sub profile_picture {
	my ( $self, $size ) = @_;
	if ($self->public && $self->data && $self->data->{gravatar_urls}) {
		if ($size) {
			return $self->data->{gravatar_urls}->{$size};
		} else {
			return $self->data->{gravatar_urls};
		}
	}
	return;
}

sub public_username {
	my ( $self ) = @_;
	if ($self->public) {
		return $self->username;
	}
	return;
}

use overload '""' => sub {
	my $self = shift;
	return 'User '.$self->username.' #'.$self->id;
}, fallback => 1;

1;
