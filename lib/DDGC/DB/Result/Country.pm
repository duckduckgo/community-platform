package DDGC::DB::Result::Country;
# ABSTRACT: Result class for a country

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use IPC::Run qw{run timeout};
use File::Temp qw/ tempfile /;
use namespace::autoclean;

table 'country';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

unique_column name_in_english => {
	data_type => 'text',
	is_nullable => 0,
};

column name_in_local => {
	data_type => 'text',
	is_nullable => 0,
};

column country_code => {
	data_type => 'text',
	is_nullable => 0,
};

column flag_svg => {
	data_type => 'text',
	is_nullable => 1,
};

column subflag_svg => {
	data_type => 'text',
	is_nullable => 1,
};
sub flag_url {}

column virtual => {
	data_type => 'tinyint',
	is_nullable => 0,
	default_value => 0,
};
sub real { shift->virtual ? 0 : 1 }

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

column primary_language_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

belongs_to 'primary_language', 'DDGC::DB::Result::Language', 'primary_language_id', { join_type => 'left' };

sub write_flag_to {
	my ( $self, $filename ) = @_;
	return 0 unless $self->flag_svg;
	my ( $in, $out, $err );
	my ( $fh1, $tempflag1 ) = tempfile;
	run [ convert => (
		$self->flag_svg,
		'-resize','512x320^',
		'-gravity','NorthWest','-extent','512x320',
		'-bordercolor','black','-border','2x2',
		$self->subflag_svg ? $tempflag1 : $filename
	) ], \$in, \$out, \$err, timeout(10) or die "$err (error $?)";
	return 1 unless $self->subflag_svg;
	#die "No subflag support yet!";
	my ( $fh2, $tempflag2 ) = tempfile;
	run [ convert => (
		$self->subflag_svg,
		'-resize','320x200',
		'-bordercolor','black','-border','2x2',
		$tempflag2
	) ], \$in, \$out, \$err, timeout(10) or die "$err (error $?)";
	run [ composite => (
		'-gravity','SouthEast',
		$tempflag2, $tempflag1, $filename
	) ], \$in, \$out, \$err, timeout(10) or die "$err (error $?)";
	return 1;
}

no Moose;
__PACKAGE__->meta->make_immutable;
