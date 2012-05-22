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
    if ($_ =~ s/\.yml$// and not $_ =~ /^\./) {
        push @all_blog_entries, $self->list_entry($_);
    }
  }
  return \@all_blog_entries;
}

sub list_entry {
  my ( $self, $uri ) = @_;
  my $entry = $self->get_entry_metadata($uri);
  $entry->{'html'} = $self->get_entry_html($uri);
  return $entry;
}

sub get_file_entry {
  my ( $self, $filename ) = @_;
  my $data = LoadFile($self->datadir.'/'.$filename);
  return shift @{$data};
}

sub get_entry_metadata {
  my ( $self, $entry ) = @_;
  return $self->get_file_entry($entry.'.yml');
}

sub get_entry_html {
  my ( $self, $entry ) = @_;
   my $entry_io = io $self->datadir . '/' . $entry . '.html';
  return $entry_io->slurp;
}

sub get_topical_entries {
  my ( $self, $topic ) = @_;
  my @all_blog_entries = $self->list_entries();
  my @topical_blog_entries;
  foreach (@all_blog_entries) {
    if ($_->[0]->{'tags'} eq $topic) {
      push @topical_blog_entries, shift @{$_};
    }
  }
  foreach (@topical_blog_entries) {
    $_->{'html'} = $self->get_entry_html($_->{'uri'});
  }
  return \@topical_blog_entries if @topical_blog_entries;
}

1;
