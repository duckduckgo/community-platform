package DDGC::DuckPAN;

use Moose;
use CPAN::Repository;

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
	$self->cpan_repository->add_author_distribution(uc($user->username),$distribution_filename);
}

1;