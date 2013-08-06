package DDGC::DB::ResultSet::Media;
# ABSTRACT: Resultset class for media entries

use Moose;
extends 'DBIx::Class::ResultSet';
use Digest::MD5 qw( md5_hex );
use Path::Class;
use File::Copy;
use URI;
use LWP::Simple;
use namespace::autoclean;

sub create_via_url {
  my ( $self, $user, $url, $args ) = @_;
  $args = {} unless defined $args;
  my $uri = URI->new($url);
  my $path = $uri->path;
  my @path_parts = split(/\//,$path);
  my $file = pop @path_parts;
  my $urldir = join("_",@path_parts);
  my $cachedir = dir($self->result_source->schema->ddgc->config->cachedir,'media_upload',$urldir);
  $cachedir->mkpath;
  my $cachefile = file($cachedir,$file);
  if (is_success(getstore($url,$cachefile->stringify))) {
    return $self->create_via_file($user,$cachefile,$args);
  }
  die "Failure on download of file";
}

sub create_via_file {
  my ( $self, $user, $file, $args ) = @_;
  $args = {} unless defined $args;
  die $file." not found!" unless -f $file;
  die __PACKAGE__."->create_via_file needs need user"
    unless $user->isa('DDGC::DB::Result::User');
  my $username = $user->username;
  my @username_parts = split(//,$username);
  my @dirparts = (shift @username_parts);
  my $next = shift @username_parts;
  push @dirparts, $next ? $next : '_';
  push @dirparts, $username;
  my $md5 = md5_hex("$file$args");
  my @md5_parts = split(//,$md5);
  push @dirparts, shift @md5_parts;
  push @dirparts, shift @md5_parts;
  push @dirparts, $md5;
  my $basename = file($file)->basename;
  my @basename_parts = split(/\./,$basename);
  my $ext = pop @basename_parts;
  my $filename = join("/",@dirparts).'.'.$ext;
  my $mediadir = $self->result_source->schema->ddgc->config->mediadir;
  my $store_file = file($mediadir,$filename);
  my $store_dir = $store_file->dir;
  $store_dir->mkpath;
  copy($file,$store_file->stringify) or die "Copy failed: $!";
  $args->{user} = $user;
  $args->{filename} = $filename;
  $args->{upload_filename} = file($file)->basename unless defined $args->{upload_filename};
  return $self->create($args);
}

no Moose;
__PACKAGE__->meta->make_immutable( inline_constructor => 0 );
