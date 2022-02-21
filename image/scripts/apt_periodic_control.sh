#!/bin/bash

#================================================================
# HEADER
#================================================================
#% SYNOPSIS
#+    apt_periodic_control.sh [false|security|all]
#+    apt_periodic_control.sh [falsk|sikkerhed|alt]
#%
#% DESCRIPTION
#%    This script controls automatic upgrades and updates.
#%
#%    It takes one optional parameter. If this parameter is missing (or if it's
#%    either "false" or "falsk"), automatic upgrades will be disabled; if it's
#%    "security" or "sikkerhed", automatic security upgrades will be enabled;
#%    and if it's anything else, automatic upgrades for all packages will be
#%    enabled.
#%
#================================================================
#- IMPLEMENTATION
#-    version         apt_periodic_control.sh (magenta.dk) 1.0.0
#-    author          Alexander Faithfull
#-    copyright       Copyright 2019, Magenta ApS
#-    license         GNU General Public License
#-    email           af@magenta.dk
#-
#================================================================
#  HISTORY
#     2019/10/16 : af : Script created
#
#================================================================
# END_OF_HEADER
#================================================================

set -ex

# Stop Debconf from doing anything
export DEBIAN_FRONTEND=noninteractive

CONF="/etc/apt/apt.conf.d/90os2borgerpc-automatic-upgrades"

if [ "$1" != "" -a "$1" != "false" -a "$1" != "falsk" ]; then
    # Check (quietly) that the unattended-upgrades package is installed, and
    # install it if it isn't
    if ! dpkg -s unattended-upgrades > /dev/null 2>&1; then
        apt-get -y install unattended-upgrades
    fi

    # Start building the configuration file with two settings, one for
    # switching unattended upgrades on and one for automatically downloading
    # updated package indexes
    cat > "$CONF" <<END
APT::Periodic::Enable "1";
APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::Update-Package-Lists "1";
END

    # Now empty the list of allowed origins and start by populating it with
    # only security-related entries
    cat >> "$CONF" <<END
#clear Unattended-Upgrade::Allowed-Origins;
Unattended-Upgrade::Allowed-Origins {
    "\${distro_id}:\${distro_codename}-security"
    ; "\${distro_id}ESM:\${distro_codename}"
END

    # Unless we've been explicitly told we should only add security-related
    # entries, then also add everything else
    if [ "$1" != "security" -a "$1" != "sikkerhed" ]; then
        cat >> "$CONF" <<END
    ; "\${distro_id}:\${distro_codename}"
END
    fi

    # Finally, close this scope and conclude the configuration file
    cat >> "$CONF" <<END
};
END
else
    # Switch automatic upgrades off entirely
    cat > "$CONF" <<END
APT::Periodic::Enable "0";
APT::Periodic::Unattended-Upgrade "0";
APT::Periodic::Update-Package-Lists "0";

#clear Unattended-Upgrade::Allowed-Origins;
END
fi
