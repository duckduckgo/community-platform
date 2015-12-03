package DDGC::DB::Result::Media;
# ABSTRACT: Media meta data

use Moose;
use MooseX::NonMoose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use IPC::Run qw{run timeout};
use Path::Class;
use namespace::autoclean;

table 'media';

column id => {
  data_type => 'bigint',
  is_auto_increment => 1,
};
primary_key 'id';

column filename => {
  data_type => 'text',
  is_nullable => 0,
};

column upload_filename => {
  data_type => 'text',
  is_nullable => 1,
};

column source_url => {
  data_type => 'text',
  is_nullable => 1,
};

column content_type => {
  data_type => 'text',
  is_nullable => 1,
};

column title => {
  data_type => 'text',
  is_nullable => 1,
};

column description => {
  data_type => 'text',
  is_nullable => 1,
};

column users_id => {
  data_type => 'bigint',
  is_nullable => 0,
};

column data => {
  data_type => 'text',
  is_nullable => 1,
  serializer_class => 'JSON',
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

sub url { '/media/'.$_[0]->filename }
sub url_thumbnail { '/thumbnail/'.$_[0]->filename }

unique_constraint [qw/ users_id filename /];

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';

after insert => sub {
  my ( $self ) = @_;
  $self->add_event('create');
};

sub generate_thumbnail {
  my ( $self ) = @_;
  my $source = file($self->ddgc->config->mediadir, $self->filename)->stringify;
  my $target = file($self->ddgc->config->mediadir, 'thumbnail', $self->filename);
  $target->dir->mkpath;
  my $size='100x100';
  my ( $in, $out, $err );
  return run [ convert => ( $source,
    '-resize', $size."^",
    '-gravity', 'center',
    '-crop', $size."+0+0",
    '+repage', $target->stringify
  )], \$in, \$out, \$err, timeout(60) or die "$err (error $?) $out";
}

no Moose;
__PACKAGE__->meta->make_immutable ( inline_constructor => 0 );
