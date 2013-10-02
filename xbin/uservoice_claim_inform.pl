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

#for my $email (keys %claim_link) {
  my $email = 'getty@duckduckgo.com';
  my ( $user, $claim_ref, $claim ) = @{$claim_link{$email}};
  my $username = $user eq 'Anonymous'
    ? "anonymous user"
    : $user;
  my $subject = "[DuckDuckGo Community] Claiming your uservoice data";
  my $text = <<"__EOT__";

Hello $username,

If you haven't already heard, we're moving off of UserVoice to our own open
source platform at https://dukgo.com/. We'll be migrating the currently
submitted ideas from http://ideas.duckduckhack.com/ to the new forum but we'd
like to make sure that users who have submitted ideas or comments can claim
them for their new community account.
  
To claim your old uservoice data, please click on the following link and login
with your community platform account (or register a new one):

https://dukgo.com/my/uservoice_claim/i175/597b27f9a35851de97921e175a1939d4

If, after login or registration, you don't get a screen informing you that your
ideas and comments are claimed, please be sure you are logged in and then retry
the link.

That's all for now but stay tuned for more updates on our way to Community 2.0.

Cheers, 

-the DuckDuckGo Staff

__EOT__
  $ddgc->postman->mail($email,'"DuckDuckGo Community Envoy" <envoy@dukgo.com>',$subject,$text);
#}
