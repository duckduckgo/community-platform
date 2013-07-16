#!/usr/bin/env perl

die "getty dont want me to start this";

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use strict;
use warnings;
use DDGC;
use DDGC::DB;
use SQL::Translator::Diff;
use IO::All;
use SQL::Translator;
use Getopt::Long;

{
	package DDGC::DBOld;
	use base qw/DBIx::Class::Schema::Loader DDGC::DB/;
	sub connect { DDGC::DB::connect(@_) }
	__PACKAGE__->naming('v5');
}

my $doupgrade = 0;

GetOptions("doupgrade" => \$doupgrade);

my $ddgc = DDGC->new;

my $schema = DDGC::DB->connect($ddgc);
my $old_schema = DDGC::DBOld->connect($ddgc);

my $old_translator = SQL::Translator->new( parser => 'SQL::Translator::Parser::DBIx::Class', parser_args => { dbic_schema => $old_schema, add_fk_index => 0 } );
my $new_translator = SQL::Translator->new( parser => 'SQL::Translator::Parser::DBIx::Class', parser_args => { dbic_schema => $schema, add_fk_index => 0 } );

my @diff = SQL::Translator::Diff::schema_diff(
	$old_translator->translate(), $old_schema->storage->sqlt_type,
	$new_translator->translate(), $schema->storage->sqlt_type,
	{ ignore_constraint_names => 1, ignore_index_names => 1, no_comments => 1 }
);

my $exit = 0;

for (@diff) {
	next if m/ DROP CONSTRAINT /;
	next if m/ ADD CONSTRAINT /;
	print $_;
	if ($doupgrade) {
		$schema->storage->dbh_do(sub {
			my ( $self, $dbh ) = @_;
			$dbh->do($_);
		});
	} else {
		$exit = 1;
	}
}

exit $exit;