#!/usr/bin/perl

use utf8;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use DDGC::DB;
use SQL::Translator::Diff;
use IO::All;
use SQL::Translator;

{
	package DDGC::DBOld;
	use base qw/DBIx::Class::Schema::Loader DDGC::DB/;
	__PACKAGE__->naming('old');
}

my $schema = DDGC::DB->connect;
my $old_schema = DDGC::DBOld->connect;

my $old_translator = SQL::Translator->new( parser => 'SQL::Translator::Parser::DBIx::Class', parser_args => { package => $old_schema, add_fk_index => 0 } );
my $new_translator = SQL::Translator->new( parser => 'SQL::Translator::Parser::DBIx::Class', parser_args => { package => $schema, add_fk_index => 0 } );

my @diff = SQL::Translator::Diff::schema_diff(
	$old_translator->translate(), $old_schema->storage->sqlt_type,
	$new_translator->translate(), $schema->storage->sqlt_type,
	{ ignore_constraint_names => 1, ignore_index_names => 1, caseopt => 1, no_comments => 1 }
);

for (@diff) {
	next if m/^-- /;
	$schema->storage->dbh_do(sub {
		my ( $self, $dbh ) = @_;
		$dbh->do($_);
	});
}

