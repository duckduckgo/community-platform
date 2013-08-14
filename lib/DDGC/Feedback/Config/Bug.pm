package DDGC::Feedback::Config::Bug;

use strict;
use warnings;

sub feedback_title { 'I need to report a bug!' }

sub feedback {[
  { description => "It's a bug on mobile (e.g. phone, tablet, media device)", icon => "phone" },
      bug_mobile(),
  { description => "It's a bug on Desktop (good ole' fashion computers)", icon => "browser" },
      bug_desktop(),
]}

sub bug_mobile {[
  { description => "The bug is in the DuckDuckGo app", icon => "dax" },
      "Please report the bug through the DuckDuckGo app by going to the Settings menu --&gt; Give Feedback. That way you don't have to type out your app version and details!",
  { description => "The bug is with DuckDuckGo in a 3rd party app or mobile browser (e.g. Safari, iCab, Dolphin)", icon => "ddg-browser" },
      bug_mobile_thirdparty(),
]}

sub bug_mobile_thirdparty {[
  { description => "I have an Android device", icon => "android" },
      bug_mobile_thirdparty_android(),
  { description => "I have an iOS device", icon => "apple" },
      bug_mobile_thirdparty_ios(),
  { description => "I have a Windows mobile device", icon => "windows8" },
      bug_mobile_thirdparty_windows(),
  { description => "I have a different type of mobile device than those listed above", icon => "phone" },
      bug_mobile_thirdparty_other(),
]}

sub bug_desktop {[
  { description => "It’s a problem with the DuckDuckGo site", icon => "dax" },
      bug_desktop_site(),
  { description => "It’s a problem with a DuckDuckGo browser addon", icon => "ddg-browser" },
      bug_desktop_addon(),
]}

sub bug_desktop_site {[
  { description => "I have a Windows computer", icon => "windows8" },
      bug_desktop_site_windows(),
  { description => "I have a Mac computer", icon => "finder" },
      bug_desktop_site_mac(),
  { description => "I have a Linux-based computer", icon => "tux" },
      bug_desktop_site_linux(),
  { description => "I have a different type of computer than those listed above", icon => "dax" },
      bug_desktop_site_other(),
]}

sub bug_desktop_addon {[
  { description => "I’m using your Firefox addon", icon => "firefox" },
      bug_desktop_addon_firefox(),
  { description => "I’m using your Chrome addon", icon => "chrome" },
      bug_desktop_addon_chrome(),
  { description => "I’m using your Safari addon", icon => "safari" },
      bug_desktop_addon_safari(),
  { description => "I’m using your Internet explorer addon", icon => "IE" },
      bug_desktop_addon_ie(),
  { description => "I’m using your Opera addon", icon => "opera" },
      bug_desktop_addon_opera(),
]}


#-----------------------------------------------------------------

sub include_bug {
  { name => 'bug', description => "The bug is", type => "textarea", icon => "bug",},
  { name => 'email', description => "Your email (not required)", type => "email", icon => "inbox",},
  { name => 'bug_steps', description => "You can reproduce it by", type => "textarea", optional => 1, placeholder => "Step-by-step instructions please", icon => "coffee"},
  { name => 'bug_other', description => $_[0] || "Other helpful info", type => "textarea", optional => 1, placeholder => 'e.g. only happens when the moon is waxing and you have underwear on your head.', icon => "folder",},
  "Submit Bug Report",
}

#-----------------------------------------------------------------

sub include_bug_app {
  { name => 'bug_app', description => "The app with the bug is called", type => "text", placeholder => "e.g. Upset Ducks", icon => "windows"},
}

sub bug_mobile_thirdparty_android {[
  { name => 'android_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Samsung Galaxy S3, HTC One", icon => "android" },
  include_bug_app(),
  include_bug(),
]}

sub bug_mobile_thirdparty_ios {[
  { name => 'ios_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Apple iPhone 5, iPad", icon => "apple" },
  include_bug_app(),
  include_bug(),
]}

sub bug_mobile_thirdparty_windows {[
  { name => 'windows_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Nokia Lumia 1020, Microsoft Surface Pro", icon => "windows8" },
  include_bug_app(),
  include_bug(),
]}

sub bug_mobile_thirdparty_other {[
  { name => 'other_mobile', description => 'My device is a', type => "text", placeholder => "e.g. Blackberry Z10, Kivo tablet", icon => "phone" },
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
  { name => $_[0].'_version', description => "My browser version is", type => "text", placeholder => $_[1], $_[2] => $_[3], optional => 1 }
}

sub bug_desktop_addon_firefox {[
  include_addon_os(),
  include_addon_version( firefox => "e.g. 21, 22, 23", icon => "firefox" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_chrome {[
  include_addon_os(),
  include_addon_version( chrome => "e.g. 28.0.1500.95", icon => "chrome" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_safari {[
  include_addon_os(),
  include_addon_version( safari => "e.g. 6.0.5", icon => "safari" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_ie {[
  include_addon_os(),
  include_addon_version( firefox => "e.g. 7, 8, 9", icon => "IE" ),
  include_bug_desktop(),
]}

sub bug_desktop_addon_opera {[ 
  include_addon_os(),
  include_addon_version( opera => "", icon => "opera" ),
  include_bug_desktop(),  
]}

#-----------------------------------------------------------------

1;
