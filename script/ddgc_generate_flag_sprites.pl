#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 
use DDGC;
use IPC::Run qw{run timeout};
use Path::Class;
use IO::All;
use POSIX qw( floor );

my $ddgc = DDGC->new;
my $schema = $ddgc->db;

my @countries = $schema->resultset('Country')->search;

my $dir = dir($ddgc->config->cachedir,'generated_images');
mkdir $dir unless -d $dir;

my $dir_css = dir($ddgc->config->cachedir,'generated_css');
mkdir $dir_css unless -d $dir_css;

my @sizes = qw( 16 24 32 64 128 256 );

my $factor = 512 / 320;

my $count = scalar @countries;

my $css = "";

print "\nGenerating flag sprite images:\n==============================\n";

for my $s (@sizes) {
  my $width = floor($s * $factor)-1;
  print "\n- Size: ".$s."\n";
  my $sprite_filename = 'flags_sprite_'.$s.'.png';
  $css .= "\n".join(", ",map { '.flag-'.$s.'--'.$_->country_code } @countries)." {\n";
  $css .= "  background-image: url('/generated_images/".$sprite_filename."');\n";
  $css .= "  height: ".$s."px;\n";
  $css .= "  width: ".$width."px;\n";
  $css .= "  display: inline-block;\n";
  $css .= "  padding: 0 !important;\n";
  $css .= "}\n\n";
  my $pos = 0;
  my @files;
  print "  Generating flags: ";
  for my $c (sort { $a->country_code cmp $b->country_code } @countries) {
    push @files, $c->flag($s);
    $css .= '.flag-'.$s.'--'.$c->country_code." {\n";
    if ($pos == 0) {
      $css .= "  background-position: 0 0\n";
    } else {
      $css .= "  background-position: 0 -".$pos."px\n";
    }
    $css .= "}\n";
    print ".";
    $pos += $s;
  }
  print " done\n";
  my ( $in, $out, $err );
  print "  Generating sprite: ";
  my $sprite = $dir->file($sprite_filename);
  run [ montage => (
    '-tile', '1x'.$count,
    '-geometry', 'x'.$s,
    @files,
    $sprite->stringify,
  )], \$in, \$out, \$err, timeout(60) or die "$err (error $?) $out";
  print "done\n";
}

print "\nGenerating css: ";
my $css_file = $dir_css->file('flags.css');
io($css_file)->print($css);
print "done\n";

print "\n";
