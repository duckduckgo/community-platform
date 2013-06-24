#!/usr/bin/env perl

die "getty dont want me to start this";

use utf8;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use DDGC;
use DDGC::DB;
use SQL::Translator::Diff;
use IO::All;
use SQL::Translator;

{
	package DDGC::DBOld;
	use base qw/DBIx::Class::Schema::Loader DDGC::DB/;
	sub connect { DDGC::DB::connect(@_) }
	__PACKAGE__->naming('old');
}

my $ddgc = DDGC->new;

my $schema = DDGC::DB->connect($ddgc);
my $old_schema = DDGC::DBOld->connect($ddgc);

my $old_translator = SQL::Translator->new( parser => 'SQL::Translator::Parser::DBIx::Class', parser_args => { package => $old_schema, add_fk_index => 0 } );
my $new_translator = SQL::Translator->new( parser => 'SQL::Translator::Parser::DBIx::Class', parser_args => { package => $schema, add_fk_index => 0 } );

my @diff = SQL::Translator::Diff::schema_diff(
	$old_translator->translate(), $old_schema->storage->sqlt_type,
	$new_translator->translate(), $schema->storage->sqlt_type,
	{ ignore_constraint_names => 1, ignore_index_names => 1, caseopt => 1, no_comments => 1 }
);

for (@diff) {
	next if m/^-- /;
	next if m/ALTER TABLE token_language DROP CONSTRAINT token_language_fk_translator_users_id/;
	next if m/ALTER TABLE token_language_translation DROP CONSTRAINT token_language_translation_token_language_id_username/;
	next if m/ALTER TABLE token_domain_language DROP CONSTRAINT token_domain_language_fk_language_id/;
	$schema->storage->dbh_do(sub {
		my ( $self, $dbh ) = @_;
		$dbh->do($_);
	});
}

