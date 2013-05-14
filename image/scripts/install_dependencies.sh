
# Find current directory

DIR=$(dirname ${BASH_SOURCE[0]})

# Install BIBOS specific dependencies
#           
# The DEPENDENCIES file contains packages/programs
# required by BibOS AND extra packages which are free dependencies
# of Skype and MS Fonts - to shorten the postinstall process.
DEPENDENCIES=( $(cat "$DIR/DEPENDENCIES") )


PKGSTOINSTALL=""

for  package in "${DEPENDENCIES[@]}"
do
    if [[ ! `dpkg -l | grep -w "ii  $package "` ]]; then
        PKGSTOINSTALL=$PKGSTOINSTALL" "$package
    fi
done

if [ "$PKGSTOINSTALL" != "" ]; then
    echo  -n "Some dependencies are missing."
    echo " The following packages will be installed: $PKGSTOINSTALL" 
    echo -n "Press ENTER to continue, CTRL-C to abort."
    read ENTER
    
    # Step 1: Check for valid APT repositories.

    sudo apt-get update &> /dev/null
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Apt repositories are not valid or cannot be reached from your network." 1>&2
        echo "Please fix and retry" 1>&2
        echo "" 1>&2
        exit -1
    else
        echo "Repositories OK: Installing packages"
    fi

    # Step 2: Do the actual installation. Abort if it fails.

    # Things to get rid of. Factor out to file if many turn up.
    sudo apt-get -y remove --purge deja-dup

    # upgrade
    sudo apt-get -y upgrade | tee /tmp/bibos_upgrade_log.txt

    # and install
    sudo apt-get -y install $PKGSTOINSTALL | tee /tmp/bibos_install_log.txt
    RETVAL=$?
    if [ $RETVAL -ne 0 ]; then
        echo "" 1>&2
        echo "ERROR: Installation of dependencies failed." 1>&2
        echo "Please note that \"universe\" repository MUST be enabled" 1>&2
        echo "" 1>&2
        exit -1
    fi
    # Clean .deb cache to save space
    sudo apt-get clean
    # We're done!
fi

