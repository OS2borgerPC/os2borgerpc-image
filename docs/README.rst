#######
License
#######

The documentation in this directory is available to you under a Creative
Commons Attribution Share-Alike License as specified here:

https://creativecommons.org/licenses/by-sa/3.0/

Please check the LICENSE file for details.

This license applies ONLY to the documentation found in this directory and
other directories which specifically contain documentation and contain the
Creative Commons license, NOT to any of the source code, which is available
under version 3 of the GNU General Public License.

##############################
How to build the documentation
##############################

The documentation is built by Read the Docs automatically, but with the Makefile you can build it locally, for reading
it locally or previewing changes to it.

To build the documentation locally:

1. Install the dependencies for sphinx, which can be done via `just`, once you have that installed:
   ..code-block:: bash
      bash
      just install-deps-ubuntu

2.
   ..code-block bash
      make html      # or run `make` with no arguments to see other options

