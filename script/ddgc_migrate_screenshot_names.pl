#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib";
use DDGC;

my $ddgc = DDGC->new;
my $screenshots = $ddgc->rs('Screenshot');

while (my $screenshot = $screenshots->next) {
    my $media = $ddgc->rs('Media')->find($screenshot->media_id) || next;
    my $user = $ddgc->rs('User')->find($media->users_id) || next;
    my $filename = $ddgc->config->mediadir . '/' . $media->filename;
    my $thumbnail = $ddgc->config->mediadir . '/thumbnail/' . $media->filename;
    ( -f $filename ) || next;
    my $newmedia = $ddgc->rs('Media')->create_via_file($user, $filename) || next;
    $newmedia->upload_filename($media->upload_filename);
    $newmedia->update;
    $screenshot->media_id($newmedia->id);
    $screenshot->update;
    unlink $filename;
    unlink $thumbnail;
}

