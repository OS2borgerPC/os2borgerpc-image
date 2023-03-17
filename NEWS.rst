Version 5.0.0, March 9, 2023
----------------------------

New in this version:

- Upgrade to Ubuntu 22.04.2.
- Clone scripts repo and install from there instead of duplicating code.
- Build in a lot more scripts - especially many security related scripts
  to provide an improved "Out of the box" experience.
- Remove some unneeded packages.
- Take a few steps to speed up the installer and reduce interactivity.
- Add firstboot script to fx. delay enabling automatic updates so rolling
  out scripts immediately after installation should work more consistently.
- Update CI-files and scripts to hopefully make it easier to upgrade to
  future versions.
- Add flag to the build process where dependency installation is skipped.

Version 4.0.0, July 15, 2022
----------------------------

New in this version:

- Rewrite build process completely for better automation and easier testing.

Version 3.1.1, February 1, 2022
-------------------------------

New in this version:

- Remove explicit locale settings from ISO.
- Remove "noisy" lines from auth.log.

Version 3.1.0, November 25, 2021
--------------------------------

New in this version:

- Icon shortcuts on desktop are handled differently - by default, none er
  present, i.e. the LibreOffice icons are removed by default.
- By default, audience users are (once again) blocked from accessing
  settings.
- Disable requests for Gnome Keyring password, e.g. from Google Chrome.
- Disable LibreOffice Tip of the Day and release notes by default.
- Link to admin site on superuser desktop now correct (bug fix).
- Wayland login option is disabled as it may cause the computer to
  become unresponsive.
- More stable process for automatic upgrades.

Version 3.0.0, January 18, 2021
-------------------------------

New in this version:

- Upgraded to Ubuntu 20.04. Major overhaul of installation process as
  well as all scripts.
- Versioning scheme changed to semantic versioning, cf.
  https://semver.org/.

Version 2.4.1.3, July 17, 2018
------------------------------

New in this version:
- Changed git repo url to the new repo url.

Version 2.4.1.2, January 2, 2018
--------------------------------

- Installation now adds the security folder and necessary security files.

Version 2.4.1.1, June 6, 2017
-----------------------------

- bibos_installtion.sh was using deleted testing branch as base for installation. This is now removed.

Version 2.4.1, June 6, 2017
---------------------------

New in this version:

- The OS2BorgerPC "Publikum" user is now called "Borger".
- The name bibos has been changed to OS2BorgerPC, every where it could be found.
- Ubuntu settings is now completely locked for user "Borger".
- Bluetooth applet is removed from top bar for user "Borger". 

Version 2.4.0, February 23, 2017
--------------------------------

New in this version:

- The bibos installation now supports Ubuntu 16.04.
- The 'Publikum' user now only has Desktop folder present in nautilus panel.

Version 2.3.0, March 22, 2016
-----------------------------

New in this version:

- The bibos installation now supports Ubuntu 12.04 and Ubuntu 14.04.
- Added new bibos_installation.sh script. It automates the bibos installation
  process. After the script has been executed the user only needs to run
  "Færdiggør BibOS installationen".
- Dependency list has been on a diet. It only contains the necessary packages
  for the bibos client to run.
- Removed gimp icon from Desktop as we do not install gimp.

Version 2.2.0, May 29, 2015
---------------------------

New in this version:

- Create new image to include the latest updates, including the upgrade
  to the latest point release, Ubuntu 12.0.4.5.
- Remove "Husk at gemme" icon from desktop.
- Include print job removal patch on image.
- Include latest bibos_client by default.

Version 2.1.0.1, October 25, 2013
---------------------------------

New in this version:

- First production ready release.
- Make sure postinstall script does not fail due to APT locking. Prevent
  apt-check from running in the background - there's no need for UpdateManager
  to launch all of a sudden (ticket #9101).
- Battery indicator was missing on audience user's login (#9089). Enable Gnome-
  settings plugin for user (presumably this was previously disabled as an
  attempt to solve #7875).
- Icons are sometimes jumbled (ticket #8279). We now don't try to specify the
  location of default desktop icons - this seems to avoid the timing problem.
- BibOS client is updated to support wireless networking cards (ticket #8951).
- BibOS client is also updated to support fixed gateway which is not
  necessarily on the same network as BibOS clients (ticket #8847).
- Script to change background image did not work unless the audience user was
  logged in (ticket #9031).
- Login screen will no longer display the users' wallpaper when they are
  selected - only the default login background is shown (ticket #9091).
- Power settings turned off monitor at login screen (ticket #7875).
- BibOS specific admin scripts moved from the bibos_admin repository to
  admin_scripts/ in this repository.
- New boot image on install disk.

Version 2.0.2.2, August 16, 2013
--------------------------------

New in this version:

- Include BibOS version in configuration for PC
- Reconfigure grub and let user choose to update PC during postinstall, cf.
  ticket #8630.
- Change a number of defaults on the image, cf. ticket #8638. These include:
  * Chrome is now available in Launcher if installed
  * Chrome shortcut renamed
  * Firefox shortcut removed from desktop
  * Downloads are sent to the user's desktop, not "Hentninger" or other specific directory
  * Shortcuts to the BibOS admin system and registration in the admin system are added to the superuser's desktop
  * autolog is installed by default
  * startup sound (drumbeat) is not played by default
- Fix Firefox settings so it won't check for add-on compatibility
- Updated documentation

Version 2.0.2.1, July 25, 2013
------------------------------

New in this version:

- Make CloneZilla build scripts easier to use, add CloneZilla documentation
- Delete *all* print jobs on logout, cf. ticket #8457
- Relabel "Login" button to "Start", cf. ticket #8372
- Do not hardcode position of desktop icons to allow new shotcuts, cf. #7749
- Add more detailed licensing information, including Creative Commons license
  for documentation
- Prompt the user before rebooting so there is time to remove the installation
  image, cf. ticket #8496

Version 2.0.2, July 12, 2013
----------------------------

New in this version:

- BibOS 2 moves from alpha to beta
- Lots of changes to the default user setup
- Completely new postinstall script
- Proxy Internet connection through local gateway
- Connect to BibOS Admin system.
- Network install works.
