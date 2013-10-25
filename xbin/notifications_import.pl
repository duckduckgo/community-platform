#!/usr/bin/env perl

$|=1;

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use DDGC;
use JSON;
use IO::All;

my $ddgc = DDGC->new;

my $json;
io('notification_export.json') > $json;

my %data = %{decode_json($json)};

for my $user ($ddgc->rs('User')->search({})->all) {
  $user->add_default_notifications;
  if (defined $data{$user->username}) {
    my %cycles = %{$data{$user->username}};
    $user->add_type_notification('forum_comments',$cycles{cycle_comment},0);
    $user->add_type_notification('company_blog_comments',$cycles{cycle_comment},0);
    $user->add_type_notification('translation_comments',$cycles{cycle_comment},0);
    $user->add_type_notification('tokens',$cycles{cycle_token},0);
    $user->add_type_notification('translations',$cycles{cycle_token_language_translation},0);
  }
}
