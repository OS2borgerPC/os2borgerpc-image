#!/usr/bin/env python3

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    grub_set_password.py PASSWORD
#%
#% DESCRIPTION
#%    This script locks all GRUB functionality, apart from booting with the
#%    default options of an installed Linux-based operating system, behind the
#%    given password.
#%
#%    It takes one mandatory parameter: the password to use. (The GRUB username
#%    associated with this password will always be "superuser".)
#%
#================================================================
#- IMPLEMENTATION
#-    version         grub_set_password.py (magenta.dk) 1.0.0
#-    author          Alexander Faithfull
#-    copyright       Copyright 2019, Magenta ApS
#-                    Portions copyright 2015 Ryan Sawhill Aroha
#-    license         GNU General Public License v3+
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2019/10/28 : af : Script created
#
#================================================================
# END_OF_HEADER
#================================================================

from os import chmod, rename, urandom
from sys import argv, exit
from hashlib import pbkdf2_hmac
from binascii import hexlify
from subprocess import run, PIPE, DEVNULL

# This function was taken from https://github.com/ryran/burg2-mkpasswd-pbkdf2
# (and lightly tweaked for use here):
#
# Copyright 2015 Ryan Sawhill Aroha <rsaw@redhat.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#    General Public License <gnu.org/licenses/gpl.html> for more details.
#
def grub2_mkpasswd_pbkdf2(passphrase,
        iterCount=100000, saltLength=64, debug=False):
    algo = "sha512"

    binSalt = urandom(saltLength)
    hexSalt = hexlify(binSalt).decode("ascii")
    passHash = hexlify(
            pbkdf2_hmac(algo, passphrase.encode("ascii"),
            binSalt, iterCount)).decode("ascii")

    if debug:
        print("algo = '{}'".format(algo))
        print("iterCount = '{}'".format(iterCount))
        print("saltLength = '{}'".format(saltLength))
        print("hexSalt = '{}'".format(hexSalt))
    return "grub.pbkdf2.{}.{}.{}.{}".format(algo, iterCount, hexSalt, passHash)


# This patch tweaks the behaviour of update-grub(1) very slightly so that the
# default launch entry for the installed operating system can be used even if
# GRUB's other functions are password-protected
diff = """\
diff --git a/10_linux b/10_linux
old mode 100644
new mode 100755
index 68700d9..b8ef18d
--- a/10_linux
+++ b/10_linux
@@ -129,7 +129,7 @@ linux_entry ()
       fi
       echo "menuentry '$(echo "$title" | grub_quote)' ${CLASS} \$menuentry_id_option 'gnulinux-$version-$type-$boot_device_id' {" | sed "s/^/$submenu_indentation/"
   else
-      echo "menuentry '$(echo "$os" | grub_quote)' ${CLASS} \$menuentry_id_option 'gnulinux-simple-$boot_device_id' {" | sed "s/^/$submenu_indentation/"
+      echo "menuentry '$(echo "$os" | grub_quote)' ${CLASS} \$menuentry_id_option 'gnulinux-simple-$boot_device_id' --unrestricted {" | sed "s/^/$submenu_indentation/"
   fi      
   if [ "$quick_boot" = 1 ]; then
       echo "   recordfail" | sed "s/^/$submenu_indentation/"
"""


def main():
    if len(argv) != 2:
        print("Syntax: {0} PASSWORD".format(argv[0]))
        exit(1)

    # Since we manually patch /etc/grub.d/10_linux (and we need that patch to
    # remain in place, or the system will become unbootable without the
    # password), instruct dpkg(1) to leave it alone!
    diversion = run(["dpkg-divert", "--add", "/etc/grub.d/10_linux"])
    if diversion.returncode is not 0:
        print("diversion failed")
        exit(1)

    # Check if we've already patched /etc/grub.d/10_linux by checking if
    # unapplying it would succeed
    already_applied = run(
            ["patch", "--dry-run", "--reverse", "--silent", "--force",
                    "/etc/grub.d/10_linux"],
            input=diff, stdout=DEVNULL, stderr=DEVNULL,
            universal_newlines=True)
    if already_applied.returncode is not 0:
        # If we haven't, then patch it now
        print("patching /etc/grub.d/10_linux")
        application = run(
                ["patch", "--silent", "--force", "/etc/grub.d/10_linux"],
                input=diff,
                universal_newlines=True)
        if application.returncode is not 0:
            print("patch failed")
            exit(1)
    else:
        print("/etc/grub.d/10_linux is already patched")

    # For safety's sake, patch(1) sometimes leaves a copy of the original file
    # behind (for example, if the patch didn't *precisely* match). If that file
    # exists, then we should make sure it's not executable so
    # that update-grub(1) won't try to run it
    try:
        chmod("/etc/grub.d/10_linux.orig", 0o600)
    except FileNotFoundError:
        pass

    # Now update /etc/grub.d/40_custom with the appropriately-hashed form of
    # the password. We do this in a slightly careful way: we populate a
    # temporary file with all of the lines from that file that *don't* have a
    # special tag comment in them (to make sure we don't leave old settings
    # lying around), after which we write two new lines with that tag comment.
    # Then we change the permissions on the temporary file to make it
    # executable and move it into place over the old one
    encoded = grub2_mkpasswd_pbkdf2(argv[1], debug=True)
    with open("/etc/grub.d/40_custom.tmp", "wt") as new:
        with open("/etc/grub.d/40_custom", "r+t") as old:
            for line in old:
                if not "# OS2borgerPC lockdown" in line:
                    new.write(line)
        new.write("set superusers=\"superuser\" # OS2borgerPC lockdown\n")
        new.write("password_pbkdf2 superuser"
                " {0} # OS2borgerPC lockdown\n".format(encoded))
    chmod("/etc/grub.d/40_custom.tmp", 0o700)
    rename("/etc/grub.d/40_custom.tmp", "/etc/grub.d/40_custom")

    # Finally, having done all of that, run update-grub(1) to generate a new
    # grub.cfg
    result = run(["update-grub"])
    if result.returncode is not 0:
        print("update-grub failed")
        exit(1)


if __name__ == '__main__':
    main()
