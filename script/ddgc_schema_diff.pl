#!/usr/bin/env perl

#die "getty dont want me to start this";

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;
use v5.10;

use DDGC;
use DDGC::DB;
use SQL::Translator::Diff;
use SQL::Translator;

{
	package DDGC::DBOld;
	use base qw/DBIx::Class::Schema::Loader DDGC::DB/;
	sub connect { DDGC::DB::connect(@_) }
	__PACKAGE__->naming('v5');
}

my $ddgc = DDGC->new;

my $schema = DDGC::DB->connect($ddgc);
my $old_schema = DDGC::DBOld->connect($ddgc);

my $old_translator = SQL::Translator->new( parser => 'SQL::Translator::Parser::DBIx::Class', parser_args => { dbic_schema => $old_schema, add_fk_index => 0 } );
my $new_translator = SQL::Translator->new( parser => 'SQL::Translator::Parser::DBIx::Class', parser_args => { dbic_schema => $schema, add_fk_index => 0 } );

$old_translator->translate; $new_translator->translate;

say SQL::Translator::Diff::schema_diff(
	$old_translator->translate(), $old_schema->storage->sqlt_type,
	$new_translator->translate(), $schema->storage->sqlt_type,
	{ ignore_constraint_names => 1, ignore_index_names => 1, no_comments => 1 }
);

