This code contains a specialized Ubuntu distribution for audience PCs in
public libraries in Denmark.

The system was prepared by Magenta Aps: See http://www.magenta-aps.dk

All code is made available under Version 3 of the GNU General Public
License - see the LICENSE and COPYRIGHT files for details.


The OS2borgerPC system is a specialized version of Ubuntu which contains one
preinstalled audience user (called "user", full name "Publikum") and one
sudo-enabled user, by convention called "superuser".

The audience user's home directory is always deleted after each logout
to ensure audience user's privacy. A number of other customizations are
performed.

The system is installed using CloneZilla. The procedure is to prepare an
installation on a physical or virtual computer, clone that system's hard
disk with CloneZilla and create a custome CloneZilla CD which is used as
the install CD (or USB, or DVD).

See the documentation in doc/ for more details.


Creating a new OS2borgerPC image from scratch
=============================================

    Start installing a vanilla Ubuntu system - Ubuntu 16.04 in the
    present example. Install on a virtual or physical machine

    Select the correct target language for installation - Danish if
    your users want to work in Danish.

    Create the initial user as Superuser - specify OS2borgerPC2 as host name.
    This is by convention, the initial user (sudo user) and host name can
    be whatever you want

    Enter a system/superuser password - IMPORTANT: Remember this

    Think about whether to select the option to encrypt the superuser's
    $HOME directory (current recommendation: Do NOT do this)

    Let the installation run its course - this may take some time

    Reboot the computer when prompted and log in with the user name and
    password you specified

    In a terminal,

    sudo apt-get install git

    # Grab the source code:

    git clone https://github.com/OS2borgerPC/image.git

    # Go to the scripts folder:

    cd image/image/scripts

    # Create standard OS2borgerPC setup:

    ./os2borgerpc_setup.sh

    # Wait - this will update, upgrade and install a lot of packages

    # Reboot to complete installation process

    Perform necessary manual configuration - prepare the installation
    so everything is ready the way our customer wants

    When done, go to the scripts folder and finalize the image:

    cd image/image/scripts
    ./finalize.sh


    This will force the postinstall script to execute automatically
    next time the system is booted.

After executing finalize, the system is ready for cloning and inclusion
in a CloneZilla image.

Boot up the system with a CloneZilla live CD and clone an image, e.g.
to your own /home/partimag using SSHFS.
