package DDGC::DB::Result::Country;
# ABSTRACT: Result class for a country

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use IPC::Run qw{run timeout};
use File::Temp qw/ tempfile /;
use File::Copy qw/ cp /;
use Path::Class;
use File::stat;
use DateTime;
use namespace::autoclean;

table 'country';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

# Alpha2 code or fake 3< letter
unique_column country_code => {
	data_type => 'text',
	is_nullable => 0,
};

unique_column name_in_english => {
	data_type => 'text',
	is_nullable => 0,
};

column name_in_local => {
	data_type => 'text',
	is_nullable => 0,
};

column flag_source => {
	data_type => 'text',
	is_nullable => 1,
};

column subflag_source => {
	data_type => 'text',
	is_nullable => 1,
};

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

column inside_country_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

belongs_to 'inside_country', 'DDGC::DB::Result::Country', 'inside_country_id', { join_type => 'left' };

has_many 'languages', 'DDGC::DB::Result::Language', 'country_id';

sub mirror_flag {
	my ( $self ) = @_;
	my $target = file( $self->ddgc->config->cachedir, 'flag_' . $self->country_code . '.orig' )->stringify;
	my $response = $self->ddgc->http->mirror( $self->flag_source, $target );
	return $target if ( $response->code eq '304' || $response->is_success );
	return undef;
}

sub write_flag_to {
	my ( $self, $filename ) = @_;
	return 0 unless $self->flag_source;
	my ( $in, $out, $err );
	my ( $fh1, $tempflag1 ) = tempfile;
	my $source = $self->mirror_flag;
	run [ convert => (
		$source,
		'-resize','512x320^',
		'-gravity','Center','-extent','512x320',
		'-bordercolor','black','-border','2x2',
		$self->subflag_source ? $tempflag1 : $filename
	) ], \$in, \$out, \$err, timeout(10) or die "$err (error $?)";
	return 1 unless $self->subflag_source;
	#die "No subflag support yet!";
	my ( $fh2, $tempflag2 ) = tempfile;
	run [ convert => (
		$self->subflag_source,
		'-resize','320x200',
		'-bordercolor','black','-border','2x2',
		$tempflag2
	) ], \$in, \$out, \$err, timeout(10) or die "$err (error $?)";
	run [ composite => (
		'-gravity','Center',
		$tempflag2, $tempflag1, $filename
	) ], \$in, \$out, \$err, timeout(10) or die "$err (error $?)";
	return 1;
}

sub flag_filename {
	my ( $self ) = @_;
	return file($self->ddgc->config->cachedir,'flag_'.$self->country_code.'.png')->stringify;
}

sub flag_url {
	my ( $self, $size ) = @_;
	$size = 24 unless $size;
	'/generated_images/flag_'.$self->country_code.'.'.$size.'.png';
}

sub flag {
	my ( $self, $size ) = @_;
	if (-f $self->flag_filename) {
		my $stat = stat($self->flag_filename);
		if (DateTime->from_epoch( epoch => $stat->mtime ) < $self->updated) {
			$self->write_flag_to($self->flag_filename);
		}
	} else {
		$self->write_flag_to($self->flag_filename);
	}
	my $filename = file($self->ddgc->config->cachedir,'flag_'.$self->country_code.'.'.$size.'.png')->stringify;
	my $thumb = file($self->ddgc->config->cachedir,'generated_images','flag_'.$self->country_code.'.'.$size.'.png')->stringify;

	$size = $size - 2;
	return unless $size > 0;
	if (-f $filename) {
		my $sized_stat = stat($filename);
		if (DateTime->from_epoch( epoch => $sized_stat->mtime ) < $self->updated) {
			unlink($filename);
		}
	}
	return $filename if -f $filename;
	my ( $in, $out, $err );
	run [ convert => (
		$self->flag_filename,
		'-resize','x'.$size,
		'-bordercolor','black','-border','1x1',
		$filename
	) ], \$in, \$out, \$err, timeout(10) or die "$err (error $?)";
	cp $filename, $thumb;
	return $filename;
}

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
