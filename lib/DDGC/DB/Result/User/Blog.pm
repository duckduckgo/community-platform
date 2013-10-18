package DDGC::DB::Result::User::Blog;
# ABSTRACT: Result class of blog posts

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use DateTime::Format::RSS;
use namespace::autoclean;

table 'user_blog';

sub u {
	my ( $self ) = @_;
	if ($self->company_blog) {
		return ['Blog', 'post', $self->uri];
	} else {
		return ['Userpage::Blog', 'post', $self->user->username, $self->uri];
	}
}

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

column translation_of_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column title => {
	data_type => 'text',
	is_nullable => 0,
};

column uri => {
	data_type => 'text',
	is_nullable => 0,
};

column teaser => {
	data_type => 'text',
	is_nullable => 0,
};

column content => {
	data_type => 'text',
	is_nullable => 0,
};
sub html {
	my ( $self ) = @_;
	return $self->content if $self->raw_html;
	return $self->ddgc->markup->html($self->content);
}

column topics => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

column company_blog => {
	data_type => 'int', # bool
	is_nullable => 0,
	default_value => 0,
};

column raw_html => {
	data_type => 'int', # bool
	is_nullable => 0,
	default_value => 0,
};

column live => {
	data_type => 'int', # bool
	is_nullable => 0,
	default_value => 0,
};

column language_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'JSON',
};

column fixed_date => {
	data_type => 'timestamp with time zone',
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

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';
belongs_to 'language', 'DDGC::DB::Result::Language', 'language_id', { join_type => 'left' };
belongs_to 'translation_of', 'DDGC::DB::Result::User::Blog', 'translation_of_id', { join_type => 'left' };

###############################

after insert => sub {
  my ( $self ) = @_;
  $self->add_event('create');
  $self->user->add_context_notification('blog_comments',$self);
};

after update => sub {
	my ( $self ) = @_;
	$self->add_event('update');
};

sub date {
	my ( $self ) = @_;
	return $self->fixed_date if $self->fixed_date;
	return $self->updated;
}

sub form_values {
	my ( $self ) = @_;
	{
		title => $self->title,
		uri => lc($self->uri),
		teaser => $self->teaser,
		content => $self->content,
		$self->topics ? ( topics => join(', ',@{$self->topics}) ) : (),
		raw_html => $self->raw_html,
		$self->fixed_date ? ( fixed_date => DateTime::Format::RSS->new->format_datetime($self->fixed_date) ) : (),
		live => $self->live,
		company_blog => $self->company_blog,
	}
}

sub update_via_form {
	my ( $self, $values ) = @_;
	my %val = %{$self->result_source->resultset->values_via_form($values)};
	for (keys %val) {
		$self->$_($val{$_});
	}
	return $self->update;
}

sub html_teaser {
	my ( $self ) = @_;
	return $self->teaser if $self->raw_html;
	return $self->result_source->schema->ddgc->markup->html($self->teaser);
}

sub human_duration_updated {
	my ( $self ) = @_;
	my $result = DateTime::Format::Human::Duration->new
		->format_duration(DateTime->now - $self->updated);
	return (split /,/, $result)[0];
}

no Moose;
__PACKAGE__->meta->make_immutable;
