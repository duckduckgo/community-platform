package DDGC::DuckPAN;

use Moose;
use CPAN::Repository;
use Dist::Data;

has ddgc => (
	isa => 'DDGC',
	is => 'ro',
	required => 1,
	weak_ref => 1,
);

has cpan_repository => (
	isa => 'CPAN::Repository',
	is => 'ro',
	lazy_build => 1,
);

sub _build_cpan_repository {
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

sub add_user_distribution {
	my ( $self, $user, $distribution_filename ) = @_;
	my $dist_data = Dist::Data->new($distribution_filename);
	my %ret;
	for (keys %{$dist_data->packages}) {
		my %perms = %{$self->get_namespace_permissions($_)};
		if (%perms) {
			if (!defined $perms{$user->username}) {
				$ret{permission_denied} = {} unless defined $ret{permission_denied};
				$ret{permission_denied}->{$_} = \%perms;
				$ret{error} = 1;
				next;
			}
		} else {
			$self->add_permission($user, $_, 1);
			$ret{new_permissions} = [] unless defined $ret{new_permissions};
			push @{$ret{new_permissions}}, $_;
		}
		$ret{namespaces} = [] unless defined $ret{namespaces};
		push @{$ret{namespaces}}, $_;
	}
	return \%ret if $ret{error};
	my $distribution_filename_duckpan = $self->cpan_repository->add_author_distribution(uc($user->username),$distribution_filename);
}

sub add_permission {
	my ( $self, $user, $namespace, $permission ) = @_;
	return $self->ddgc->db->resultset('DuckPAN::Permission')->create({
		namespace => $namespace,
		users_id => $user->id,
		permission => $permission,
	});
}

sub get_namespace_permissions {
	my ( $self, $namespace ) = @_;
	my @permissions = $self->ddgc->db->resultset('DuckPAN::Permission')->search({
		namespace => $namespace
	})->all;
	my %perms;
	for (@permissions) {
		$perms{$_->user->username} = $_->permission;
	}
	return \%perms;
}

1;