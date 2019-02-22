#!/usr/bin/env perl

use Moo;
use MooX::Options;

use File::Spec::Functions;
use File::Path qw/ make_path /;
use File::Copy;
use IO::All -utf8;
use HTML::TreeBuilder::LibXML;
use File::Find;
use Try::Tiny;

use FindBin;
use lib $FindBin::Dir . "/../lib";

has ddgc => ( is => 'lazy' );
sub _build_ddgc {
    require DDGC;
    DDGC->new;
}

has now => (
    is => 'ro',
    default => sub { time() }
);

has ddgc_dir => ( is => 'lazy' );
sub _build_ddgc_dir {
    $_[0]->ddgc->config->rootdir_path
}

has help_dir => ( is => 'lazy' );
sub _build_help_dir {
    my ( $self ) = @_;
    $self->_mkdir( $self->ddgc_dir, 'help' );
}

has pkg_dir => ( is => 'lazy' );
sub _build_pkg_dir {
    my ( $self ) = @_;
    $self->_mkdir( $self->help_dir, $self->now );
}

has img_dir => ( is => 'lazy' );
sub _build_img_dir {
    my ( $self ) = @_;
    $self->_mkdir( $self->pkg_dir, 'images' );
}

has user => ( is => 'lazy' );
sub _build_user {
    my ( $self ) = @_;
    $self->ddgc->find_user('ddgc');
}

has tarball => ( is => 'lazy' );
sub _build_tarball {
    my ( $self ) = @_;
    catfile( $self->ddgc_dir, 'media', 'help-' . $self->now . '.tar.bz2' );
}

sub _mkdir {
    my ( $self, @dir ) = @_;
    my $d = catdir( @dir );
    make_path $d unless -d $d;
    return $d;
}

sub dir_for {
    my ( $self, @dir ) = @_;
    my $d = catdir( $self->pkg_dir, @dir );
    make_path $d unless -d $d;
    return $d;
}

sub filename_for {
    $_[1] =~ s{.*/}{}r;
}

sub write_markup {
    my ( $self, $help ) = @_;
    my $content = join " ",
                  map { $_->content_html }
                  $help->help_contents->all;
    my $category = $help->help_category ? $help->help_category->key : undef;
    return unless $category;
    my $d = $self->dir_for( '_docs', $category );
    my $title = $help->help_contents->one_row->title;
    my $filename = lc($title) =~ s/\s+/-/gr;

    my $tree = HTML::TreeBuilder::LibXML->new;
    $tree->parse( $content );
    $tree->eof;

    for my $node ( $tree->findnodes('//img') ) {
        my $src = $node->attr('src');
        if ( $src =~ m{^https?://}i ) {
            my $m;
            try {
                $m = $self->ddgc->rs('Media')->create_via_url( $self->user, $src );
            } catch {
                warn "Downloading $src failed : $_";
            };
            next unless $m;
            $src = '/media/' . $m->filename;
        }
        copy( catfile( $self->ddgc->config->rootdir_path, $src ), $self->img_dir );
        $src = $self->filename_for( $src );

        $node->attr( 'src', "/images/$src" );
    }

    $content = sprintf(
        "---\ntitle: %s\ncategory: %s\norder: %s\n---\n",
        $title,
        ucfirst($category),
        $help->sort // 9999,
    );
    $content .= $tree->as_HTML =~ s{</br>}{}mgr;

    $content > io( catfile( $d, $help->key . '.html' ) );
}

sub export_helps {
    my ( $self ) = @_;
    my @helps = $self->ddgc->rs('Help')
        ->prefetch([ qw/ help_category help_contents / ])
        ->all;
    for my $help ( @helps ) {
         $self->write_markup( $help );
    }
}

sub zip_helps {
    my ( $self ) = @_;
    chdir $self->pkg_dir;
    system( qw/ tar cjf /, $self->tarball, '.' );
    printf( "Wrote %s\n", $self->tarball ) unless $? != 0;
}

sub go {
    my ( $self ) = @_;
    $self->export_helps;
    $self->zip_helps;
}

main->new_with_options->go;
