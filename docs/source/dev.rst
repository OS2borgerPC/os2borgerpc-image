Technical Documentation
=======================


********************************
Creating a new OS2borgerPC image
********************************

PREREQUISITES: squashfs-tools genisoimage p7zip-full xorriso isolinux

# Resources about how to build or tweak this:

- https://help.ubuntu.com/community/LiveCDCustomization
- https://wiki.ubuntu.com/UbiquityAutomation
- https://wiki.ubuntu.com/DesktopCDOptions
- https://help.ubuntu.com/lts/installation-guide/amd64/apbs01.html

cd to the ``image`` directory:
$ cd image

From this directory, run the following command:

$ ./build_os2borgerpc_image.sh iso_path image_name

"iso_path" is a path to the ISO image to be remastered.

"image_name" is the name of the output image, e.g. "OS2borgerPC-x.y.z". The 
output ISO file will be called "$image_name".iso.


*********************************************************
Convert a vanilla Ubuntu installation into an OS2borgerPC
*********************************************************

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

To install OS2borgerPC, you need the ``prepare_os2borgerpc.sh``
file. You'll find it in this repository, in
``image/build/prepare_os2borgerpc.sh``. You can also read
that file and perform the commands manually, step by step.

Change execution rights for the installation file. Open a terminal:

.. code-block:: bash

	sudo chmod +x prepare_os2borgerpc.sh

Start the installation:

.. code-block:: bash

	./prepare_os2borgerpc.sh

Now the system is ready to be connected to the admin system.

When the system is rebooted the system log in as superuser so
the "Registrer i OS2borgerPC Admin" script can be executed from the Desktop.
