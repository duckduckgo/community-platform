package DDGC::DuckPAN;
# ABSTRACT: Functions to access http://duckpan.org/ CPAN repository

use Moose;
use CPAN::Repository;
use Dist::Data;
use Path::Class;
use Archive::Tar;
use File::chdir;
use JSON::MaybeXS;
use DateTime;
use IO::All -utf8;
use File::ShareDir::ProjectDistDir;
use Archive::Tar;
use version;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

sub cpan_repository {
	my ( $self ) = @_;
	my $repo = CPAN::Repository->new({
		dir => $self->ddgc->config->duckpandir,
		url => $self->ddgc->config->duckpan_url,
		written_by => (ref $self),
	});
	$repo->initialize unless $repo->is_initialized;
	return $repo;
}

sub modules { shift->cpan_repository->modules }

sub get_release {
	my ( $self, $name, $version ) = @_;
	my ( $release ) = $self->ddgc->db->resultset('DuckPAN::Release')->search({
		name => $name,
		version => $version,
	})->all;
	return $release;
}

sub log {
	my $self = shift;
	my $text = join(" ",@_);
	io($self->ddgc->config->duckpanlog)->append(
		"[".(DateTime->now->datetime)."] ".$text."\n"
	);
}

sub add_user_distribution {
	my ( $self, $user, $distribution_filename ) = @_;
	$distribution_filename = file($distribution_filename)->absolute->stringify;
	$self->log($user->lc_username,"adds",$distribution_filename);
	my $dist_data = Dist::Data->new($distribution_filename);
	unless ($user->admin) {
		$self->log("ERROR",$user->lc_username,"is no admin, adding denied");
		return 'Only admins may upload so far ('.$user->username.')';
	}
	unless ($user->email) {
		$self->log("ERROR",$user->lc_username,"has no email, adding denied");
		return 'You need an email to upload ('.$user->username.')';
	}
	my @releases = $self->ddgc->db->resultset('DuckPAN::Release')->search({
		name => $dist_data->name,
#		version => $dist_data->version,
	})->all;
	my $dist_data_version = $dist_data->version;
	my $dist_data_name = $dist_data->name;
	for (@releases) {
		if ($_->version eq $dist_data_version) {
			$self->log("ERROR",$dist_data->name,$dist_data_version,"already uploaded");
			return 'Distribution version ('.$_->version.') already uploaded';
		}
		if (version->parse($_->version) > $dist_data_version) {
			$self->log("ERROR",$dist_data_name,$dist_data_version,"already uploaded");
			return 'Higher version ('.$_->version.') already uploaded';
		}
	}
	my $distribution_filename_duckpan = $self->cpan_repository->add_author_distribution(uc($user->username),$distribution_filename);
	$self->log("Adding release",$dist_data_name,$dist_data_version);
	my $release = $self->add_release( $user, $dist_data_name, $dist_data_version, $distribution_filename_duckpan);
	if ($@) {
		$self->log("ERROR",'Could not generate documentation for',$dist_data_name,$dist_data_version,$@);
		return "Failed to parse your POD. Perhaps you should test it first?";
	}

	if($release){
		if(my $e = $self->update_release_versions($dist_data_version, $distribution_filename)){
			$self->log("ERROR",$e,$dist_data_name,$dist_data_version);
			return $e;
		}
	}
	return $release // "This... this is not possible.";
}

sub add_release {
	my ( $self, $user, $release_name, $release_version, $filename ) = @_;
	$self->ddgc->db->resultset('DuckPAN::Release')->search({
		name => $release_name,
	})->update({ current => 0 });
	return $self->ddgc->db->resultset('DuckPAN::Release')->create({
		name => $release_name,
		version => $release_version,
		users_id => $user->id,
		filename => $filename,
	});
}

sub update_release_versions {
	my ($s, $version, $file) = @_;

	my $ia_types = qr{(?:Goodie|Spice|Fathead|Longtail)};

	my $repo;
	if($file =~ m{-($ia_types)Bundle-}){
		$repo = lc $1;
		$repo = 'goodies' if $repo eq 'goodie';
	}
	else{
		return "Failed to extract repo type from $file";
	}

	my $db = $s->ddgc->db;
	my $rvs = $db->resultset('ReleaseVersion');
	my $ias = $db->resultset('InstantAnswer')->search({
		repo => $repo,
		dev_milestone => 'complete'
	});

	my $a = Archive::Tar->new($file);
	for my $f ($a->list_files){
		my $where;
		if($f =~ m{lib/(DDG/$ia_types/.+)\.pm$}){
			my $m = $1;
			$m =~ s|/|::|g;
			$where = {perl_module => $m};
			if($m =~ /CheatSheets$/){
				$where->{id} = 'cheat_sheets';
			}
		}
		elsif($f =~ m{share/goodie/cheat_sheets/json/.+\.json$}){
			my $c = $a->get_content($f);
			my $cs = decode_json($c);
			$where = {meta_id => $cs->{id}};
		}

		if($where && (my $ia = $ias->single($where))){
			$ia->update({
				release_version => $version,
				dev_milestone => 'released'
			});
			$rvs->create({
				instant_answer_id => $ia->meta_id,
				release_version => $version,
				status => 'released'
			});
		}
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
