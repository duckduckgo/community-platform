package DDGC::Feedback::Config::Love;

use strict;
use warnings;

sub feedback_title { 'I want to tell you about something I love!' }

sub feedback {[
  { description => "Everyone seems to find something they particularly love about DuckDuckGo. Whether it's <a href='https://duckduckgo.com/privacy'>privacy</a>, <a href='https://duckduckgo.com/goodies'>instant answers</a>, <a href='https://duckduckgo.com/bang.html'>!bangs</a>, or a variety of other features --- we always love to hear what makes you smile. Please, use the box below to elaborate:", type => "info" },
  { name => "love", description => "I love", type => "textarea" },
  { name => 'email', description => "Your email (not required)", type => "email", },  
  "Submit love",
]}

1;
