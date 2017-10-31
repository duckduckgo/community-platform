package DDGC::Feedback::Config::Feature;
# ABSTRACT:

use strict;
use warnings;

sub feedback_title { "I've got a feature request." }

sub feedback {[
  { description => "We'd love your suggestions!. Please check our <a href='https://duck.co/help'>Help pages</a> for common requests like making an email service or a browser. If you can't find what you're looking for, use the options below:", type => "info", icon => "newspaper", },

  { description => "It's a feature", icon => "sun" },
    "Please share your idea with the DuckDuckGo community on our subreddit: <a href='https://www.reddit.com/r/duckduckgo/'>reddit.com/r/duckduckgo</a>",

  { description => "It's a translation request", icon => "globe" },
    "You can translate DuckDuckGo to your language through the <a href='https://duck.co/translate'>Community Platform</a>. If you don't see your language available, please request it <a href='https://duck.co/my/requestlanguage'>here</a>.",
    "" # workaround for non submittable ending points like this here.
]}

1;
