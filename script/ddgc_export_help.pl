#!/usr/bin/env perl

use Moo;
use MooX::Options;

use File::Spec::Functions;
use File::Path qw/ make_path /;
use File::Copy;
use IO::All -utf8;
use HTML::TreeBuilder::LibXML;

use FindBin;
use lib $FindBin::Dir . "/../lib";

has ddgc => ( is => 'lazy' );
sub _build_ddgc {
    require DDGC;
    DDGC->new;
}

has target_dir => ( is => 'lazy' );
sub _build_target_dir {
    my ( $self ) = @_;
    my $d = catdir( $self->ddgc->config->rootdir_path, 'help', time );
    make_path $d unless -d $d;
    return $d;
}

has user => ( is => 'lazy' );
sub _build_user {
    my ( $self ) = @_;
    $self->ddgc->find_user('ddgc');
}

sub dir_for {
    my ( $self, $dir ) = @_;
    my $d = catdir( $self->target_dir, $dir );
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
    my $d = $self->dir_for( $help->help_category->key );

    my $tree = HTML::TreeBuilder::LibXML->new;
    $tree->parse( $content );
    $tree->eof;

    for my $node ( $tree->findnodes('//img') ) {
        my $src = $node->attr('src');
        if ( $src =~ m{^https?://}i ) {
            my $m = $self->rs('Media')->create_via_url( $self->user, $src );
            $src = $m->filename;
        }
        copy( catfile( $self->ddgc->config->rootdir_path, $src ),
              $self->target_dir );
        $src = $self->filename_for( $src );

        $node->attr( 'src', $src );
    }

    $content = $tree->guts->as_HTML =~ s{</br>}{}mgr;

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

sub go {
    my ( $self ) = @_;
    $self->export_helps;
}

main->new_with_options->go;
