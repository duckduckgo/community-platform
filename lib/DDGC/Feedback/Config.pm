package DDGC::Feedback::Config;

use strict;
use warnings;

sub bug {[
  "It's a bug on mobile (e.g. phone, tablet, media device)",
      bug_mobile(),
  "It's a bug on Desktop (good ole' fashion computers)",
      bug_desktop(),
]}

sub bug_mobile {[
  "The bug is in the DuckDuckGo app",
      "Please report the bug through the DuckDuckGo app by going to the Settings menu --&gt; Give Feedback. That way you don't have to type out your app version and details!",
  "The bug is with DuckDuckGo in a 3rd party app or mobile browser (e.g. Safari, iCab, Dolphin)",
      bug_mobile_thirdparty(),
]}

sub bug_mobile_thirdparty {[
  "I have an Android device",
      bug_mobile_thirdparty_android(),
  "I have an iOS device",
      bug_mobile_thirdparty_ios(),
  "I have a Windows mobile device",
      bug_mobile_thirdparty_windows(),
  "I have a different type of mobile device than those listed above",
      bug_mobile_thirdparty_other(),
]}

sub bug_desktop {[
  "It’s a problem with the DuckDuckGo site",
      bug_desktop_site(),
  "It’s a problem with a DuckDuckGo browser addon",
      bug_desktop_addon(),
]}

sub bug_desktop_site {[
  "I have a Windows computer",
      bug_desktop_site_windows(),
  "I have a Mac computer",
      bug_desktop_site_mac(),
  "I have a Linux-based computer",
      bug_desktop_site_linux(),
  "I have a different type of computer than those listed above",
      bug_desktop_site_other(),
]}

sub bug_desktop_addon {[
  "I’m using your Firefox addon",
      bug_desktop_addon_firefox(),
  "I’m using your Chrome addon",
      bug_desktop_addon_chrome(),
  "I’m using your Safari addon",
      bug_desktop_addon_safari(),
  "I’m using your Internet explorer addon",
      bug_desktop_addon_ie(),
  "I’m using your Opera addon",
      bug_desktop_addon_opera(),
]}


#-----------------------------------------------------------------

sub include_bug {
  { name => 'bug', description => "The bug is", type => "textarea", },
  { name => 'bug_email', description => "Your email", type => "email", },
  { name => 'bug_steps', description => "The steps to reproduce the bug are", type => "textarea", optional => 1, },
  { name => 'bug_other', description => $_[0] || "Other helpful info", type => "textarea", optional => 1, },
  "Submit bugreport",
}

#-----------------------------------------------------------------

sub include_bug_app {
  { name => 'bug_app', description => "The app with the bug is called", type => "text", },
}

sub bug_mobile_thirdparty_android {[
  { name => 'android_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Samsung Galaxy S3, HTC One" },
  include_bug_app(),
  include_bug(),
]}

sub bug_mobile_thirdparty_ios {[
  { name => 'ios_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Apple iPhone 5, iPad" },
  include_bug_app(),
  include_bug(),
]}

sub bug_mobile_thirdparty_windows {[
  { name => 'windows_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Nokia Lumia 1020, Microsoft Surface Pro" },
  include_bug_app(),
  include_bug(),
]}

sub bug_mobile_thirdparty_other {[
  { name => 'other_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Blackberry Z10, Kivo tablet" },
  include_bug_app(),
  include_bug(),
]}

#-----------------------------------------------------------------

sub include_os {
  { name => $_[0].'_os', description => 'My operating system is', type => "text", placeholder => $_[1] },
}

sub include_os_windows { include_os( windows => "e.g. Windows XP, Windows 8" ) }
sub include_os_mac { include_os( mac => "e.g. Mac OSX 10.7.5" ) }
sub include_os_linux { include_os( linux => "e.g. Ubuntu 13.0.4, Linux Mint" ) }
sub include_os_other { include_os( other => "" ) }

sub include_browser {
  { name => $_[0].'_browser', description => 'The browser I use is', type => "text", placeholder => $_[1] },
}

sub include_browser_windows { include_browser( windows => "e.g. Internet Explorer 8, Firefox 23, Chrome 28" ) }
sub include_browser_mac { include_browser( mac => "e.g. Safari 6.0.5, Firefox, Chrome" ) }
sub include_browser_linux { include_browser( linux => "e.g. Firefox 23, Epiphany 3.8.2" ) }
sub include_browser_other { include_browser( other => "" ) }

sub include_bug_desktop {
  include_bug("Other helpful info (e.g. Do you use any custom DuckDuckGo settings? Do you have any other addons installed to your browser?)");
}

sub bug_desktop_site_windows {[
  include_os_windows(),
  include_browser_windows(),
  include_bug_desktop(),
]}

sub bug_desktop_site_mac {[
  include_os_mac(),
  include_browser_mac(),
  include_bug_desktop(),
]}

sub bug_desktop_site_linux {[
  include_os_windows(),
  include_browser_linux(),
  include_bug_desktop(),
]}

sub bug_desktop_site_other {[
  include_os_other(),
  include_browser_other(),
  include_bug_desktop(),
]}

sub include_addon_os {
  include_os( addon => "e.g. Windows 8, MacOSX 10.7.5" )
}

sub include_addon_version {
  { name => $_[0].'_version', description => "My browser version is", type => "text", placeholder => $_[1], optional => 1 }
}

sub bug_desktop_addon_firefox {[
  include_addon_os(),
  include_addon_version( firefox => "e.g. 21, 22, 23" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_chrome {[
  include_addon_os(),
  include_addon_version( chrome => "e.g. 28.0.1500.95" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_safari {[
  include_addon_os(),
  include_addon_version( safari => "e.g. 6.0.5" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_ie {[
  include_addon_os(),
  include_addon_version( firefox => "e.g. 7, 8, 9" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_opera {[
  include_addon_os(),
  include_addon_version( opera => "" ),
  include_bug_desktop(),
]}

1;
