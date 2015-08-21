package DDGC::DB::Result::Token::Domain;
# ABSTRACT: A token domain

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;

use Path::Class;
use DDGC::Util::Po;
use Text::Fuzzy;

use namespace::autoclean;

table 'token_domain';

sub u { [ 'Translate', 'domainindex', shift->key ] }

sub u_untranslated { [ 'Translate', 'domainuntranslated', shift->key ] }
sub u_unvoted { [ 'Translate', 'domainunvoted', shift->key ] }

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

unique_column key => {
	data_type => 'text',
	is_nullable => 0,
};

column name => {
	data_type => 'text',
	is_nullable => 0,
};

column description => {
	data_type => 'text',
	is_nullable => 1,
};

column data => {
	data_type => 'text',
	is_nullable => 1,
	serializer_class => 'YAML',
};

column sorting => {
	data_type => 'int',
	is_nullable => 0,
	default_value => 0,
};

column active => {
	data_type => 'tinyint',
	is_nullable => 0,
	default_value => 1,
};

column source_language_id => {
	data_type => 'int',
	is_nullable => 0,
};

column sticky_notes => {
	data_type => 'text',
	is_nullable => 1,
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

has_many 'tokens', 'DDGC::DB::Result::Token', 'token_domain_id', {
	cascade_delete => 1,
};

has_many 'token_domain_languages', 'DDGC::DB::Result::Token::Domain::Language', 'token_domain_id', {
	cascade_delete => 1,
};

belongs_to 'source_language', 'DDGC::DB::Result::Language', 'source_language_id', {
	on_delete => 'no action',
	on_update => 'no action',
};

many_to_many 'languages', 'token_domain_languages', 'language';

after insert => sub {
  my ( $self ) = @_;
  $self->add_event('create');
};

has _name_parts => (
	is => 'ro',
	lazy_build => 1,
);

sub _build__name_parts {
	my ( $self ) = @_;
	my @parts = qw( DDGC Locale );
	my $key = $self->key;
	push @parts, join('',map { ucfirst($_) } split('-',$key));
	return \@parts;
}

has dist_name => (
	is => 'ro',
	lazy_build => 1,
);

sub _build_dist_name {
	my ( $self ) = @_;
	return join('-',@{$self->_name_parts});
}

sub is_duckduckgo {
	my ( $self ) = @_;
	my @parts = split('-',$self->key);
	return $parts[0] eq 'duckduckgo' ? 1 : 0;
}

has lib_name => (
	is => 'ro',
	lazy_build => 1,
);

sub _build_lib_name {
	my ( $self ) = @_;
	return join('::',@{$self->_name_parts});
}

sub comments {
	my ( $self, $page, $pagesize ) = @_;
	$self->result_source->schema->resultset('Comment')->search({
		context => 'DDGC::DB::Result::Token::Language',
		context_id => { -in => $self->token_domain_languages->search_related('token_languages')->get_column('id')->as_query },
	},{
		order_by => { -desc => 'me.updated' },
		( ( defined $page and defined $pagesize ) ? (
			page => $page,
			rows => $pagesize,
		) : () ),
		prefetch => 'user',
	});
}

sub token_domain_languages_locale_sorted {
	my ( $self ) = @_;
	$self->token_domain_languages->search({},{
		order_by => 'language.locale',
		prefetch => 'language',
	});
}

sub generate_pos {
	my ( $self, $dir, $generator, $fallback ) = @_;
	for my $tcl ($self->token_domain_languages->all) {
		my $locale = $tcl->language->locale;
		my $basedir = dir($dir,$locale,'LC_MESSAGES');
		$basedir->mkpath(0,0755);
		$tcl->generate_po_for_locale_in_dir_as_with_fallback($basedir, $generator, $fallback);
	}
}

sub get_po_entries {
	my ( $self ) = @_;
	my @token_results = $self->tokens->all;
	my @pos;
	for (@token_results) {
		my %po;
		$po{msgid} = $_->msgid;
		$po{msgid_plural} = $_->msgid_plural if $_->msgid_plural;
		$po{msgctxt} = $_->msgctxt if $_->msgctxt;
		push @pos, \%po;
	}
	return @pos;
}

sub analyze_po_entries {
	my ( $self, @tokens ) = @_;
	my ( $new, $old ) = $self->intersect_po_entries(@tokens);
	for (@{$new}) {
		my @similar = $self->similar_po_entries($_);
		$_->{similar} = \@similar;
	}
	return {
		new => $new,
		old => $old,
	}
}

sub migrate_po_entries {
	my ( $self, @tokens ) = @_;
	my ( $new, $old ) = $self->intersect_po_entries(@tokens);
	my @new_tokens;
	for (@{$new}) {
		push @new_tokens, $self->create_related('tokens',{
			msgid => $_->{msgid},
			defined $_->{msgid_plural} ? ( msgid_plural => $_->{msgid_plural} ) : (),
			defined $_->{msgctxt} ? ( msgctxt => $_->{msgctxt} ) : (),
		});
	}
	return @new_tokens;
}

sub similar_po_entries {
	my ( $self, $po ) = @_;
	my $tf = Text::Fuzzy->new($po->{msgid});
	$tf->transpositions_ok(1);
	$tf->set_max_distance(100);
	my %by_msgid;
	for ($self->get_po_entries) {
		$by_msgid{$_->{msgid}} = [] unless defined $by_msgid{$_->{msgid}};
		push @{$by_msgid{$_->{msgid}}}, $_;
	}
	return unless %by_msgid;
	my $keys = [keys %by_msgid];
	my @similar = map { @{$by_msgid{$keys->[$_]}} } $tf->nearest($keys);
	my $size = scalar @similar;
	my $max_index = $size >= 5 ? 4 : $size-1;
	return @similar[0..$max_index];
}

sub intersect_po_entries {
	my ( $self, @tokens ) = @_;
	my %new_token = %{token_hash(@tokens)};
	my %has_token = %{token_hash($self->get_po_entries)};
	my @new;
	my @old;
	for (keys %new_token) {
		my $val = $new_token{$_};
		if (defined $has_token{$_}) {
			push @old, $val;
		} else {
			push @new, $val;
		}
	}
	return \@new, \@old;
}

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
