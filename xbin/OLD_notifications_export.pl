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

my %data;

for my $user ($ddgc->rs('User')->search({})->all) {
  my $un_token = $ddgc->rs('User::Notification')->search({
    users_id => $user->id,
    context => 'DDGC::DB::Result::Token',
    context_id => undef,
  })->first;
  my $un_comment = $ddgc->rs('User::Notification')->search({
    users_id => $user->id,
    context => 'DDGC::DB::Result::Comment',
    context_id => undef,
  })->first;
  my $un_tlt = $ddgc->rs('User::Notification')->search({
    users_id => $user->id,
    context => 'DDGC::DB::Result::Token',
    context_id => undef,
  })->first;
  if ($un_token || $un_comment || $un_tlt) {
    $data{$user->username} = {
      defaultcycle_comments => $user->defaultcycle_comments,
      defaultcycle_blogthreads => $user->defaultcycle_blogthreads,
      cycle_token => $un_token ? $un_token->cycle : 0,
      cycle_comment => $un_comment ? $un_comment->cycle : 0,
      cycle_token_language_translation => $un_tlt ? $un_tlt->cycle : 0,
    };
  }
}

use DDP; p(%data);

io('notification_export.json')->print(encode_json(\%data));
