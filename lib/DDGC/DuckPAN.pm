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
use CPAN::Documentation::HTML;
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

sub cpan_documentation_html {
	my ($self) = @_;
	my $cdh = CPAN::Documentation::HTML->new({
		root => $self->ddgc->config->duckpandir,
                assets => {
                    'default.css' => file(dist_dir('DDGC'), 'docroot_duckpan', 'duckpan.css'),
                    'default.png' => file(dist_dir('DDGC'), 'docroot_duckpan', 'logo.png'),
                },
	});
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
        eval {
		my $cdh = $self->cpan_documentation_html;
		$cdh->add_dist($distribution_filename);
		$cdh->save_cache;
		$cdh->save_index;
        };
        if ($@) {
            $self->log("ERROR",'Could not generate documentation for',$dist_data->name,$dist_data->version,$@);
            return "Failed to parse your POD. Perhaps you should test it first?";
        }
	eval {
		$self->ddgc->db->txn_do(sub {
			my $latest_dir = dir($self->ddgc->config->duckpandir,'latest',$dist_data->name);
			$latest_dir->mkpath unless -d $latest_dir;
			{
				local $CWD = $latest_dir;
				my $next = Archive::Tar->iter($distribution_filename, 1);
				while (my $f = $next->()) {
					my @path_parts = split('/',$f->full_path);
					shift @path_parts;
					$f->extract(join('/',@path_parts));
				}
			}
			my %modules;
			if (-d $latest_dir->subdir('lib')) {
				my $lib = $latest_dir->subdir('lib');
				my ( @pods, @pms );
				$lib->traverse(sub {
					my $b = $_[0]->basename;
					if ($b =~ qr!\.pm$!) {
							push @pms, $_[0];
					} elsif ($b =~ qr!\.pod$!) {
							push @pods, $_[0];
					}
					return $_[1]->();
				});
				for my $file (@pods) {
					my @parts = $file->relative($lib)->components;
					my $filename = pop @parts;
					$filename =~ s!\.pod$!!;
					my $module = join('::',@parts,$filename);
					$modules{$module} = {} unless defined $modules{$module};
					$modules{$module}->{filename_pod} = $file->relative($latest_dir)->stringify;
				}
				for my $file (@pms) {
					my @parts = $file->relative($lib)->components;
					shift @parts if $parts[0] eq '.';
					my $filename = pop @parts;
					$filename =~ s!\.pm$!!;
					my $module = join('::',@parts,$filename);
					$modules{$module} = {} unless defined $modules{$module};
					$modules{$module}->{filename} = $file->relative($latest_dir)->stringify;
				}
			}
			my %meta;
			if (-f $latest_dir->file('duckpan.json')) {
				%meta = %{decode_json(scalar $latest_dir->file('duckpan.json')->slurp)};
			}
			$release->duckpan_meta(\%meta);
			for my $module (keys %modules) {
				$self->ddgc->db->resultset('DuckPAN::Module')->update_or_create({
					name => $module,
					duckpan_release_id => $release->id,
					defined $meta{$module} ? ( duckpan_meta => $meta{$module} ) : (),
					%{$modules{$module}},
				},{
					key => 'duckpan_module_name',
				});
			}
		});
	};
	if ($@) {
		$release->duckpan_meta({ error => $@ });
		$self->log(ERROR => $dist_data->name, $dist_data->version, $@);
		return 'Error! '.$@;
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
