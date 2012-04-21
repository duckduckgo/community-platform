package DDGC::Blog;

use Moose;
use File::ShareDir::ProjectDistDir;
use YAML qw( LoadFile );
use IO::All;

has datadir => (
	is => 'ro',
	isa => 'Str',
	required => 1,
);

sub list_entries {
  my ( $self ) = @_;
  my $datadir_io = io($self->datadir);
  my @all_blog_entries;
  for (keys %$datadir_io) {
    push @all_blog_entries, $self->_get_file_entry($_);
  }
  return \@all_blog_entries;
}

sub _get_file_entry {
	my ( $self, $filename ) = @_;
	my $data = LoadFile($self->datadir.'/'.$filename);
	return shift @{$data};
}

sub get_entry {
	my ( $self, $entry ) = @_;
	return $self->_get_file_entry($entry.'.yml');
}

1;