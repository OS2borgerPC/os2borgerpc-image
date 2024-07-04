##########################
Hardware with Known Issues
##########################

The following is a list of computer models that are known to have issues
with OS2borgerPC. The list is continuously updated as we discover or
receive reports of new models with issues.

.. list-table::
    :widths: 10 5
    :header-rows: 1
    :stub-columns: 1

    * - Model
      - Comment
    * - Lenovo V14 G4 AMD
      - The built-in mouse and keyboard did not work.
    * - Intel NUC5CPYB
      - | The desktop does not work correctly after
        | installing image 5.0.0 (Ubuntu 22.04).
    * - | Lenovo Thinkpad T14 Gen3
        | Lenovo Thinkpad T16 Gen1
      - | After installing image 5.0.0 or an older image,
        | the computer will not boot correctly. However,
        | this can be fixed with a script.
    * - Intel NUC kit NUC7CJYHN
      - | The screen periodically flickers. The problem
        | only occurs intermittently and can be detected
        | during startup. As a workaround, we have a
        | script that will restart the computer if the
        | problem is detected.

If you know of any other computer models that have issues with
OS2borgerPC, you are invited to contact us so that they can be
added to the list.
