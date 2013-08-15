package DDGC::Feedback::Config::Bang;

use strict;
use warnings;

sub feedback_title { 'I’d like to submit a new !bang or report a broken !bang.' }

sub feedback {[
  { description => 'To submit new !bangs, use this page: <a href="https://duckduckgo.com/newbang">https://duckduckgo.com/newbang</a>.', type => "info" },
  { description => 'To let us know about a broken <a href="https://duckduckgo.com/bang.html">!bang</a>, please use this guide:', type => "info" },
  { name => "bang", description => "The !bang that doesn’t work is", type => "text", placeholder => "e.g. !wikipedia, !so, !ebay" },
  { name => "issue", description => "The issue is that", type => "text", placeholder => "e.g. the site returns an error, the site no longer exists" },
  { name => 'email', description => "Your email (not required)", type => "email", },
  "Report broken !bang",
]}

1;
