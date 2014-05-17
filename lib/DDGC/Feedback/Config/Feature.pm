package DDGC::Feedback::Config::Feature;
# ABSTRACT:

use strict;
use warnings;

sub feedback_title { "I've got a feature request." }

sub feedback {[
  { description => "We really appreciate you taking the time to offer your suggestions. Some of the common ones we get are to make an <a href='https://duck.co/help/features/email'>email service</a> and <a href='https://duck.co/help/desktop/adding-duckduckgo-to-your-browser'>web browser</a>. If you haven't found what you're looking for in the <a href='https://duck.co/help/'>Help pages</a>, please use the guide below to tell us what you'd like to see in DuckDuckGo:", type => "info", icon => "newspaper", },
  { description => "It's a feature that could be an instant answer", icon => "sun" },

    "Please submit instant answer ideas to our community voting platform at <a href='http://duck.co/ideas/'>http://duck.co/ideas/</a>. If you're a developer, you can even make them yourself at <a href='http://duckduckhack.com/'>http://duckduckhack.com/</a>. For some inspiration, check out the current instant answers here <a href='https://duckduckgo.com/goodies'>https://duckduckgo.com/goodies</a>.",

  { description => "It's a feature that wouldn’t work as an instant answer", icon => "coffee" },
    "Please submit your idea to our community platform forums so others can help expand (or even develop) your idea: <a href='https://duck.co/'>https://duck.co/</a>",

  { description => "It's a translation request", icon => "globe" },
    "You can translate DuckDuckGo to your language through the <a href='https://duck.co/translate'>community platform</a>.",
    "" # workaround for non submittable ending points like this here.
]}

1;
