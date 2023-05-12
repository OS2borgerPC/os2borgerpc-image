#!/bin/bash

set -x

printf "\n\n%s\n\n" "===== RUNNING: $0 (INSIDE SQUASHFS) ====="

export LANG_ALL="$1"

# You have entered the squashed system as root.
export DEBIAN_FRONTEND=noninteractive

# Step 1: Check for valid APT repositories.
apt-get update &> /dev/null
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    echo "" 1>&2
    echo "ERROR: Apt repositories are not valid or cannot be reached from your network." 1>&2
    echo "Please fix and retry" 1>&2
    echo "" 1>&2
    exit 1
else
    echo "Repositories OK"
fi

echo "Removing packages we don't need, before we upgrade all packages:"
# Things to get rid of. Factor out to file if many turn up.
# deja-dup because...?
# libfprint-2-2 because it fails during installation/updating because of an unmet interactive step, but we don't need finger print reading anyway so we can delete it
# ...and the rest because they likely aren't needed by users
apt-get --assume-yes remove --purge apport cheese deja-dup evince libfprint-2-2 gnome-todo openvpn remmina thunderbird totem transmission-gtk whoopsie

if [ ! "$LANG_ALL" ]; then
    # Danish image version: Remove unneeded language support, as the installer seems to otherwise spend a decent amount of time removing them during the installation
    # Exit if this fails, which it can do if a package name changes
    apt-get -y remove --purge language-pack-de-base language-pack-de language-pack-es-base language-pack-es language-pack-fr-base language-pack-fr language-pack-gnome-de-base language-pack-gnome-de language-pack-gnome-en-base language-pack-gnome-en language-pack-gnome-es-base language-pack-gnome-es language-pack-gnome-fr-base language-pack-gnome-fr language-pack-gnome-it-base language-pack-gnome-it language-pack-gnome-pt-base language-pack-gnome-pt language-pack-gnome-ru-base language-pack-gnome-ru language-pack-gnome-zh-hans-base language-pack-gnome-zh-hans language-pack-it-base language-pack-it language-pack-pt-base language-pack-pt language-pack-ru-base language-pack-ru language-pack-zh-hans-base language-pack-zh-hans libreoffice-help-de libreoffice-help-es libreoffice-help-fr libreoffice-help-it libreoffice-help-pt-br libreoffice-help-pt libreoffice-help-ru libreoffice-help-zh-cn libreoffice-help-zh-tw libreoffice-l10n-de libreoffice-l10n-en-za libreoffice-l10n-es libreoffice-l10n-fr libreoffice-l10n-it libreoffice-l10n-pt-br libreoffice-l10n-pt libreoffice-l10n-ru libreoffice-l10n-zh-cn libreoffice-l10n-zh-tw hunspell-de-at-frami hunspell-de-ch-frami hunspell-de-de-frami hunspell-es hunspell-fr-classical hunspell-fr hunspell-it hunspell-pt-br hunspell-pt-pt hunspell-ru ibus-hangul libhangul-data libhangul1 gnome-user-docs-de gnome-user-docs-es gnome-user-docs-fr gnome-user-docs-it gnome-user-docs-pt gnome-user-docs-ru gnome-user-docs-zh-hans hyphen-de hyphen-es hyphen-fr hyphen-it hyphen-pt-br hyphen-pt-pt hyphen-ru || exit 1
fi

# Run customization, from the image/image directory which is bind-mounted in
/mnt/image/scripts/os2borgerpc_setup.sh || exit 1

# Ideally at this point nothing else within the image is installed/uninstalled, so we can clean up old package versions etc.
apt-get --assume-yes autoremove --purge
apt-get --assume-yes clean

/mnt/image/scripts/finalize.sh || exit 1
