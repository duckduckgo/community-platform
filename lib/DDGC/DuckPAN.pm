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
	for (@releases) {
		if ($_->version eq $dist_data->version) {
			$self->log("ERROR",$dist_data->name,$dist_data->version,"already uploaded");
			return 'Distribution version ('.$_->version.') already uploaded';
		}
		if (version->parse($_->version) > $dist_data->version) {
			$self->log("ERROR",$dist_data->name,$dist_data->version,"already uploaded");
			return 'Higher version ('.$_->version.') already uploaded';
		}
	}
	my $distribution_filename_duckpan = $self->cpan_repository->add_author_distribution(uc($user->username),$distribution_filename);
	$self->log("Adding release",$dist_data->name,$dist_data->version);
	my $release = $self->add_release( $user, $dist_data->name, $dist_data->version, $distribution_filename_duckpan);
        if ($@) {
            $self->log("ERROR",'Could not generate documentation for',$dist_data->name,$dist_data->version,$@);
            return "Failed to parse your POD. Perhaps you should test it first?";
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

no Moose;
__PACKAGE__->meta->make_immutable;
