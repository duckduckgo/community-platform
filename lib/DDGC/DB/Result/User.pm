package DDGC::DB::Result::User;
# ABSTRACT: Result class of a user in the DB

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use Digest::MD5 qw( md5_hex );
use namespace::autoclean;

table 'users';

sub u_userpage {
	my ( $self ) = @_;
	return ['Root','default'] unless $self->public_username;
	return ['Userpage','home',$self->public_username];
}

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

column email => {
	data_type => 'text',
	is_nullable => 1,
};

column gravatar_email => {
	data_type => 'text',
	is_nullable => 1,
};

column userpage => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
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

column profile_media_id => {
	data_type => 'bigint',
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

around data => sub {
	my ( $orig, $self, @args ) = @_;
	my $data = $orig->($self,@args);
	$data = {} unless $data;
	return $data;
};

has_many 'token_language_translations', 'DDGC::DB::Result::Token::Language::Translation', { 'foreign.username' => 'self.username' };
has_many 'token_languages', 'DDGC::DB::Result::Token::Language', 'translator_users_id';
has_many 'checked_translations', 'DDGC::DB::Result::Token::Language::Translation', 'check_users_id';
has_many 'translation_votes', 'DDGC::DB::Result::Token::Language::Translation::Vote', 'users_id';
has_many 'comments', 'DDGC::DB::Result::Comment', 'users_id';
has_many 'duckpan_releases', 'DDGC::DB::Result::DuckPAN::Release', 'users_id';
has_many 'threads', 'DDGC::DB::Result::Thread', 'users_id';
has_many 'ideas', 'DDGC::DB::Result::Idea', 'users_id';
has_many 'events', 'DDGC::DB::Result::Event', 'users_id';
has_many 'medias', 'DDGC::DB::Result::Media', 'users_id';

has_many 'event_notifications', 'DDGC::DB::Result::Event::Notification', 'users_id';

has_many 'user_languages', 'DDGC::DB::Result::User::Language', { 'foreign.username' => 'self.username' };
has_many 'user_notifications', 'DDGC::DB::Result::User::Notification', 'users_id';
has_many 'user_blogs', 'DDGC::DB::Result::User::Blog', 'users_id';

many_to_many 'languages', 'user_languages', 'language';

belongs_to 'profile_media', 'DDGC::DB::Result::Media', 'profile_media_id', { join_type => 'left' };

# WORKAROUND
sub db { return shift; }

sub translation_manager { shift->is('translation_manager') }

sub is {
	my ( $self, $role ) = @_;
	return 0 unless $role;
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

sub translation_count { shift->token_language_translations->count(@_); }
sub event_notifications_undone_count { shift->event_notifications->search({
	done => 0,
},{
	cache_for => 30,
})->count; }

sub blog { shift->user_blogs_rs }

sub profile_picture {
	my ( $self, $size ) = @_;

	return unless $self->public;

	my $gravatar_email;

	if ($self->data && defined $self->data->{gravatar_email}) {
		$gravatar_email = $self->data->{gravatar_email};
	}

	if ($self->data && defined $self->data->{userpage} && defined $self->data->{userpage}->{gravatar_email}) {
		$gravatar_email = $self->data->{userpage}->{gravatar_email};
	}

	if ($self->userpage && defined $self->userpage->{gravatar_email}) {
		$gravatar_email = $self->userpage->{gravatar_email};
	}

	return unless $gravatar_email;

	my $md5 = md5_hex($gravatar_email);

	my %return;
	for (qw/16 32 48 64 80/) {
		$return{$_} = "//www.gravatar.com/avatar/".$md5."?r=g&s=$_";
	}

	if ($size) {
		return $return{$size};
	} else {
		return \%return;
	}
}

sub public_username {
	my ( $self ) = @_;
	if ($self->public) {
		return $self->username;
	}
	return;
}

sub last_comments {
	my ( $self, $page, $pagesize ) = @_;
	$self->comments->search({},{
		order_by => { -desc => [ 'me.updated', 'me.created' ] },
		( ( defined $page and defined $pagesize ) ? (
			page => $page,
			rows => $pagesize,
		) : () ),
		prefetch => 'user',
	});
}

has user_notification_group_values => (
	isa => 'HashRef',
	is => 'ro',
	lazy_build => 1,
	clearer => 'clear_user_notification_group_values',
);

sub _build_user_notification_group_values {
	my ( $self ) = @_;
	my %user_notification_group_values;
	for ($self->search_related('user_notifications',{
		context_id => undef,
	},{
		join => [qw( user_notification_group )],
	})->all) {
		$user_notification_group_values{$_->user_notification_group->type} = {}
			unless defined $user_notification_group_values{$_->user_notification_group->type};
		my $context_id_key = $_->user_notification_group->with_context_id
			? '*' : '';
		$user_notification_group_values{$_->user_notification_group->type}->{$context_id_key}
			= { cycle => $_->cycle, xmpp => $_->xmpp };
	}
	return \%user_notification_group_values;
}

sub add_context_notification {
	my ( $self, $type, $context_obj ) = @_;
	my $group_info = $self->user_notification_group_values->{$type}->{'*'};
	if ($group_info->{cycle}) {
		my @user_notification_groups = $self->schema->resultset('User::Notification::Group')->search({
			context => $context_obj->context_name,
			with_context_id => 1,
			type => $type,
		})->all;
		die "Several notification groups found, cant be..." if scalar @user_notification_groups > 1;
		die "No notification group found!" if scalar @user_notification_groups < 1;
		my $user_notification_group = $user_notification_groups[0];
		return $self->create_related('user_notifications',{
			user_notification_group_id => $user_notification_group->id,
			xmpp => $group_info->{xmpp} ? 1 : 0,
			cycle => $group_info->{cycle},
			context_id => $context_obj->id,
		});
	}
}

sub add_type_notification {
	my ( $self, $type, $cycle, $with_context_id ) = @_;
	my @user_notification_groups = $self->schema->resultset('User::Notification::Group')->search({
		with_context_id => $with_context_id ? 1 : 0,
		type => $type,
	})->all;
	die "No notification group found!" if scalar @user_notification_groups < 1;
	for my $user_notification_group (@user_notification_groups) {
		$self->update_or_create_related('user_notifications',{
			user_notification_group_id => $user_notification_group->id,
			context_id => undef,
			cycle => $cycle,
		},{
			key => 'user_notification_user_notification_group_id_context_id_users_id',
		});
		if ($with_context_id) {
			$self->search_related('user_notifications',{
				user_notification_group_id => $user_notification_group->id,
				context_id => { '!=' => undef },
			})->update({
				cycle => $cycle,
			});
		}
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
