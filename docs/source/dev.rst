Technical Documentation
=======================


Creating a new OS2borgerPC image from scratch
*********************************************

Start installing a vanilla Ubuntu system - Ubuntu 20.04 in the
present example. Install on a virtual or physical machine. If
installing in a virtual machine, be sure to use UEFI boot - the
install scripts currently don't handle images with legacy boot well
(there is no trouble installing on machines with legacy boot,
though).

Select the correct target language for installation - Danish if your
users want to work in Danish.

Create the initial user as Superuser - specify os2borgerpc as host name.
This is by convention, the initial user (sudo user) and host name
can be whatever you want

Enter the standard OS2borgerPC password (if you don't know it, ask
someone or choose your own).

To install OS2borgerPC, you need the ``os2borgerpc_installation.sh``
file. You'll find it in this repository, in
``image/scripts/os2borgerpc_installation.sh``. You can also read
that file and perform the commands manually, step by step.

If this installation is for a clonezilla image, you'll probably want
to open ``os2borgerpc_installation.sh`` and remove the reboot
command at line 41.

# Change execution rights for the installation file. 

Open a terminal,

.. code-block:: bash

	sudo chmod +x os2borgerpc_installation.sh

# Start the installation:

.. code-block:: bash

	./os2borgerpc_installation.sh

Now the system is ready to be cloned as a Clonezilla image or 
to be connected to the admin system.

When the system is rebooted the system will log in as superuser so
the "Færdiggør os2borgerpc installation" can be executed. 	 

If it is for a CloneZilla image, boot up the system with a CloneZilla
live CD and clone an image, e.g. to your own /home/partimag using SSHFS.

See the separate guide on how to do this.


Guide to saving an image of a hard disk prepared for OS2borgerPC installation
*****************************************************************************

To save a hard disk image for use in creating an OS2borgerPC installation disk,
download a Clonezilla iso from http://clonezilla.org/ and boot it on the
machine with the hard disk.
Then follow the guide at

https://clonezilla.org/show-live-doc-content.php?topic=clonezilla-live/doc/01_Save_disk_image

but choose to save a single partition instead of the whole disk. The partition
you want to save is the main partition you installed Ubuntu on and is probably
called sda1.

Once the disk image has been saved, it can be used to create an installation
disk. See the files HOWTOBuild_BibOS_CD_from_clonezilla_image.txt and
How-to-build-an-OS2borgerPC-installation-USB-stick-from-an-existing-Clonezilla-image.md
in this directory for more information.


How to build an OS2borgerPC installation image from an existing Clonezilla image
********************************************************************************

Check out the code

.. code-block:: bash

	git clone https://github.com/OS2borgerPC/image.git
	cd image


Download a stable Clonezilla live archive

The download link is
https://clonezilla.org/downloads/download.php?branch=stable. (These
instructions have worked with versions 2.5.6-22 and 2.6.0-37.)

Unzip this archive to a new folder with the name of the image you
want to create

.. code-block:: bash

	unzip path/to/clonezilla-live.zip -d OS2borgerPC_2019-02-13_M/


Overwrite parts of Clonezilla with OS2borgerPC-specific configuration
files

.. code-block:: bash

	./image/scripts/do_overwrite_clonezilla.sh OS2borgerPC_2019-02-13_M/


Copy the OS2borgerPC hard disk image files to the `bibos-images/bibos_default/` directory

.. code-block:: bash

	cp -r /path/to/image/* OS2borgerPC_2019-02-13_M/bibos-images/bibos_default/


Create an ISO image from it

.. code-block:: bash

	./image/scripts/make_bootable_iso.sh OS2borgerPC_2019-02-13_M


The resulting ISO image is a working boot disk, supporting both modern
EFI and traditional `isohybrid`-based boot processes, and can be written
directly to a USB stick or used as a CD-ROM image to set up a virtual
machine.

