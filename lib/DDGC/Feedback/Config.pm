package DDGC::Feedback::Config;

use strict;
use warnings;

sub report_bug {[
  "It's a bug on mobile (e.g. phone, tablet, media device)",
      report_bug_mobile(),
  "It's a bug on Desktop (good ole' fashion computers)",
      "report_bug_desktop()",
  "It's a problem with a DuckDuckGo browser addon",
      "report_bug_addon()",
]}

sub report_bug_mobile {[
  "The bug is in the DuckDuckGo app",
      "Please report the bug through the DuckDuckGo app by going to the Settings menu --&gt; Give Feedback. That way you don't have to type out your app version and details!",
  "The bug is with DuckDuckGo in a 3rd party app or mobile browser (e.g. Safari, iCab, Dolphin)",
      report_bug_mobile_thirdparty(),
]}

sub report_bug_mobile_thirdparty {[
  "I have an Android device",
      report_bug_mobile_thirdparty_android(),
  "I have an iOS device",
      report_bug_mobile_thirdparty_ios(),
  "I have a Windows mobile device",
      report_bug_mobile_thirdparty_windows(),
  "I have a different type of mobile device than those listed above",
      report_bug_mobile_thirdparty_other(),
]}

sub include_mobile_bug {
  { name => 'bug_app', description => "The app with the bug is called", type => "text", },
  { name => 'bug', description => "The bug is", type => "textarea", },
  { name => 'bug_steps', description => "The steps to reproduce the bug are", type => "textarea", optional => 1, },
  { name => 'bug_other', description => "Other helpful info", type => "textarea", optional => 1, },
  "Submit bugreport",
}

sub report_bug_mobile_thirdparty_android {[
  { name => 'android_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Samsung Galaxy S3, HTC One" },
  include_mobile_bug(),
]}

sub report_bug_mobile_thirdparty_ios {[
  { name => 'ios_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Apple iPhone 5, iPad" },
  include_mobile_bug(),
]}

sub report_bug_mobile_thirdparty_windows {[
  { name => 'windows_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Nokia Lumia 1020, Microsoft Surface Pro" },
  include_mobile_bug(),
]}

sub report_bug_mobile_thirdparty_other {[
  { name => 'other_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Blackberry Z10, Kivo tablet" },
  include_mobile_bug(),
]}

1;
