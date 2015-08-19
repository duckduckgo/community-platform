package DDGC::DB::Result::Token;
# ABSTRACT:

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'token';

sub u { 
	my ( $self ) = @_;
	[ 'Translate', 'token', $self->id ]
}

sub event_related {
	my ( $self ) = @_;
	['DDGC::DB::Result::Token::Domain', $self->token_domain_id]
}

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column msgid => {
	data_type => 'text',
	is_nullable => 0,
};

column msgid_plural => {
	data_type => 'text',
	is_nullable => 1,
};

column msgctxt => {
	data_type => 'text',
	is_nullable => 1,
};

#
# Token Type
#
# 0: not listed
# 1: snippet
# 2: free text (no plural forms, may include HTML)
# 3: image (no plural forms)
#
column type => {
	data_type => 'tinyint',
	is_nullable => 0,
	default_value => 1,
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

column token_domain_id => {
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

column retired => {
	data_type => 'tinyint',
	is_nullable => 0,
	default_value => 0,
};

belongs_to 'token_domain', 'DDGC::DB::Result::Token::Domain', 'token_domain_id';

has_many 'token_languages', 'DDGC::DB::Result::Token::Language', 'token_id';

after insert => sub {
  my ( $self ) = @_;
  $self->add_event('create');
};

sub has_placeholders {
	my ( $self ) = @_;
	my @all_placeholders;
	my %placeholders = %{$self->placeholders};
	push @all_placeholders, @{$placeholders{msgid}};
	push @all_placeholders, @{$placeholders{msgid_plural}} if defined $placeholders{msgid_plural};
	return scalar @all_placeholders;
}

my $placeholders_regexp = qr/%(\d+\$)?([-+\'#0 ]*)(\*\d+\$|\*|\d+)?(\.(\*\d+\$|\*|\d+))?([scboxXuidfegEG])/;

sub _parse_placeholders {
	my ( $self, $string ) = @_;
	my @matches = $string =~ /$placeholders_regexp/g;
	my @placeholders;
	for (@matches) {
		push @placeholders, $_ if $_;
	}
	return @placeholders;
}

sub placeholders {
	my ( $self ) = @_;
	my %placeholders = (
		msgid => [$self->_parse_placeholders($self->msgid)],
	);
	$placeholders{msgid_plural} = [$self->_parse_placeholders($self->msgid_plural)] if $self->msgid_plural;
	return \%placeholders;
}

sub insert {
	my $self = shift;
	my $guard = $self->result_source->schema->txn_scope_guard;
	$self->next::method(@_);
	for ($self->token_domain->token_domain_languages->all) {
		$self->create_related('token_languages',{
			token_domain_language_id => $_->id,
		});
	}
	$guard->commit;
	return $self;
}

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
