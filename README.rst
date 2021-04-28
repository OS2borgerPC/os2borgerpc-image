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

See the documentation in docs/ for more details.
