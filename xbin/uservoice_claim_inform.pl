#!/usr/bin/env perl

$|=1;

use strict;
use warnings;

use FindBin;
use lib $FindBin::Dir . "/../lib"; 

use DDP;
use DDGC;

my $ddgc = DDGC->new;
my $db = $ddgc->db;

my @ideas = $db->resultset('Idea')->search({
  data => { -like => '%uservoice_claim%' },
})->all;
my @comments = $db->resultset('Comment')->search({
  data => { -like => '%uservoice_claim%' },
})->all;

my %claim_link;
my %user_email;

for (@ideas,@comments) {
  next unless $_->data->{uservoice_email};
  my $email = $_->data->{uservoice_email};
  my $user = $_->data->{uservoice_user};
  my $claim = $_->data->{uservoice_claim};
  my $claim_ref = ref $_ eq 'DDGC::DB::Result::Comment' ? 'c' : 'i';
  $claim_ref .= $_->id;
  if (defined $user_email{$email}) {
    die "Different username for same email" if $user_email{$email} ne $user;
  } else {
    $user_email{$email} = $user;
    $claim_link{$email} = [$user,$claim_ref,$claim];
  }
}

for (keys %claim_link) {
  p($_);
  my $email = 'getty@duckduckgo.com';
  my ( $user, $claim_ref, $claim ) = @{$claim_link{$_}};
  ####
  my $username = $user eq 'Anonymous'
    ? "anonymous user"
    : $user;
  my $subject = "[DuckDuckGo Community] Claiming your uservoice data";
  my %stash;
  $stash{email_username} = $username;
  $stash{email_claimlink} = $ddgc->config->web_base.'/my/uservoice_claim/'.$claim_ref.'/'.$claim;
  $c->d->postman->template_mail(
    $email,
    '"DuckDuckGo Community" <noreply@dukgo.com>',
    $subject,
    'uservoiceclaim',
    $c->stash,
  );
}
