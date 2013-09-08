package DDGC::LocaleDist;
# ABSTRACT: Generating a distribution of the translations of a token domain for DuckPAN

use Moose;
use DateTime;
use DateTime::Format::Strptime;
use File::Temp qw/ tempdir /;
use Path::Class;
use IO::All -utf8;
use Cwd;
use Data::Dumper;
use POSIX;
use MIME::Base64;
use Encode qw(encode);

our $VERSION ||= '0.0development';

has token_domain => (
	is => 'ro',
	required => 1,
	isa => 'DDGC::DB::Result::Token::Domain',
);

has generator => (
	is => 'ro',
	lazy_build => 1,
);

sub _build_generator { 'DDGC::LocaleDist '.$VERSION }

has fallback => (
	is => 'ro',
	lazy_build => 1,
);

sub _build_fallback { 1 }

has version => (
	is => 'ro',
	lazy_build => 1,
);

sub _build_version {
	my ( $self ) = @_;
	DateTime::Format::Strptime->new(
		pattern => '%Y%m%d.%H%M%S',
	)->format_datetime(DateTime->now(
		locale => 'en_US',
		time_zone => 'Pacific/Easter',
	));
}

has year => (
	is => 'ro',
	lazy_build => 1,
);

sub _build_year {
	my ( $self ) = @_;
	DateTime::Format::Strptime->new(
		pattern => '%Y',
	)->format_datetime(DateTime->now(
		locale => 'en_US',
		time_zone => 'Pacific/Easter',
	));
}

has build_dir => (
	is => 'ro',
	lazy_build => 1,
);

sub _build_build_dir { dir(tempdir()) }

has _distribution_file => (
	is => 'rw',
);
sub distribution_file { shift->_distribution_file }

sub BUILD {
	my ( $self ) = @_;

	my $dist = $self->token_domain->dist_name;
	my $lib = $self->token_domain->lib_name;
	my $version = $self->version;
	my $year = $self->year;

	my @lib_dir_parts = split('::',$lib);
	my $lib_file = (pop @lib_dir_parts).".pm";
	my $lib_dir = dir($self->build_dir,'lib',@lib_dir_parts);
	my $testdir = dir($self->build_dir,'t');

	my $tokencount = $self->token_domain->tokens->search()->count;
	my $domainname = $self->token_domain->name;

	my %locales;
	my $localesstring = "{\n";
	for my $tcl ($self->token_domain->token_domain_languages->all) {
		my $translation_count = 0;
		for my $tl ($tcl->token_languages->all) {
			$translation_count++ if $tl->gettext_snippet(0);
		}
		my $locale = $tcl->language->locale;
		$localesstring .= "'".$locale."' => {\n";
		$localesstring .= "\ttranslation_count => ".$translation_count.",\n";
		$localesstring .= "\tpercent => ".floor( ($tokencount ? ($translation_count / $tokencount) : (0)) * 100 ).",\n";
		$localesstring .= "\tlocale => '".$locale."',\n";
		my $eb64ename = encode_base64(encode("UTF-8", $tcl->language->name_in_english)); chomp($eb64ename);
		$localesstring .= "\tname_in_english => decode_base64('".$eb64ename."'),\n";
		my $eb64lname = encode_base64(encode("UTF-8", $tcl->language->name_in_local)); chomp($eb64lname);
		$localesstring .= "\tname_in_local => decode_base64('".$eb64lname."'),\n";
		$localesstring .= "\tnplurals => ".$tcl->language->nplurals.",\n";
		$localesstring .= "\trtl => ".($tcl->language->rtl ? 1 : 0).",\n";
		if ($tcl->language->country) {
			$localesstring .= "\tcountry_code => '".$tcl->language->country->country_code."',\n";
			$localesstring .= "\tvirtual_country => '".($tcl->language->country->virtual ? 1 : 0)."',\n";
			my $eb64cename = encode_base64(encode("UTF-8", $tcl->language->country->name_in_english)); chomp($eb64cename);
			$localesstring .= "\tcountry_name_in_english => decode_base64('".$eb64cename."'),\n";
  		my $eb64clname = encode_base64(encode("UTF-8", $tcl->language->country->name_in_local)); chomp($eb64clname);
			$localesstring .= "\tcountry_name_in_local => decode_base64('".$eb64clname."'),\n";
		}
		if ($tcl->language->parent) {
			$localesstring .= "\tparent_locale => '".$tcl->language->parent->locale."',\n";
		}
		$localesstring .= "},\n";
	}
	$localesstring .= "}\n";

	io(file($self->build_dir,'dist.ini'))->print(<<"___END_OF_DIST_INI___");
name = $dist
author = DuckDuckGo Community <community\@duckduckgo.com>
license = Perl_5
copyright_holder = DuckDuckGo Community <community\@duckduckgo.com>
copyright_year = $year

version = $version

[Prereqs / TestRequires]
Test::More = 0.88

[GatherDir]
[PruneCruft]
[ManifestSkip]
[PodWeaver]
[PkgVersion]
[PkgDist]
[MetaYAML]
[License]
[ShareDir]
[MakeMaker]
[Manifest]

___END_OF_DIST_INI___

	$lib_dir->mkpath(0,0755);
	io(file($lib_dir,$lib_file))->print(<<"___END_OF_LIB___");
package $lib;
# ABSTRACT: Translations for $domainname

use strict;
use warnings;
use MIME::Base64;

\=method version

Gives back the version of this translation package. Strftime form: %Y%m%d.%H%M%S

\=cut

sub version { '$version' }

\=method token_count

Amount of token in the specific given domain.

\=cut

sub token_count { $tokencount }

\=method locales

Information about the included locales

\=cut

sub locales {$localesstring}

1;
___END_OF_LIB___

	$testdir->mkpath(0,0755);
	io(file($testdir,'00-load.t'))->print(<<"___END_OF_LOAD_T___");
#!/usr/bin/perl

use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok('$lib');
}

done_testing;
___END_OF_LOAD_T___

	my $sharedir = dir($self->build_dir,'share');
	$sharedir->mkpath(0,0755);
	$self->token_domain->generate_pos($sharedir,$self->generator,$self->fallback);

	system("cd ".$self->build_dir."; dzil build");

	my $dist_file = file($self->build_dir,$dist.'-'.$version.'.tar.gz');

	die "Building failed! see error above" unless -f $dist_file;

	$self->_distribution_file($dist_file);

}

no Moose;
__PACKAGE__->meta->make_immutable;
