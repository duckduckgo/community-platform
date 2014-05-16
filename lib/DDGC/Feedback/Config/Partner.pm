package DDGC::Feedback::Config::Partner;
# ABSTRACT:

use strict;
use warnings;

sub feedback_title { "I'd like to learn about partnerships with DuckDuckGo" }

sub feedback {[
  { name => "partner_url", description => "What is the URL for your product or organization? ", type => "text", icon => "globe" },
  { name => "partner_description", description => "How do you see your organization and DuckDuckGo working together? ", type => "textarea", icon => "dax" },
  { name => 'submit', description => "Send", icon => "mail", cssclass => "fb-step--submit" }
]}

1;
