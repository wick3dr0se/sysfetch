#How to Build:

### Current Builds:
* makefile
* .DEB
* .RPM
* .pkg (for MacOS)
* pacman

###Current Builds Capabilities:
Currently sysfetch is built for .RPM, .DEB, MacOS, and pacman (Arch family) based systems, in addition to having a makefile so it can reasonably be used on nearly any UNIX based system. It will run as a standard shell script on both the Windows Subsystem for Linux 2, as well as Cygwin, though tests for those are ongoing.

###Building from Source:
The program is written in bash shell script, so execution is easy, and doesn't require compiling:
* `chmod +x sysfetch`
* `./sysfetch`

*Ensure that the components folder is in the same directory as the script or it will not execute properly.*

###Building sysfetch into a Package:
Though generally taken care of, if you wish to build a package to test your contributions, we use the `fpm` build system here: [`fpm` Installation and how-to](https://fpm.readthedocs.io/en/latest/installation.html).

The maintainer will be producing packages and releasing them, as well as versioning them, this is available just to allow the casual user to test changes to

Once installed and you've verified that `fpm` is working we do this to get ourselves a .deb package:



    fpm \
    -s dir -t deb \
    -p sysfetch-0.1.0-1-any.deb \
    --name sysfetch \
    --license gpl3 \
    --version 0.1.0 \
    --architecture all \
    --depends bash \
    --description "A super tiny Linux system information sysfetch script written in BASH" \
    --url "https://example.com/hello-world" \
    --maintainer "wick3dr0se <https://github.com/wick3dr0se/sysfetch>" \
    --after-install build/beforeinstall.sh \
    --after-remove build/afterinstall.sh \
    components=/usr/lib/sysfetch/ sysfetch=/usr/lib/sysfetch/sysfetch sysfetch.1=/usr/share/man/man1/sysfetch.1 License.md=/usr/lib/sysfetch/License

You'll notice that each line is pretty straightforward. The only one that really requires explanation is the very last line that begins with: `components`.

This line lists out where certain files and folders in the main directory will end up installed on the target system.

An example of part of the string: `sysfetch = /usr/lib/sysfetch/sysfetch` means:
sysfetch will be moved to the /usr/lib/sysfetch/sysfetch directory on installation.

So, if we were to add a theoretical `sysfetchpart2` script to the build, and we want it in the /usr/lib/sysfetch directory on the target install system, we'd render it this way:

`sysfetchpart2=/usr/lib/sysfetch`

#### What about other package types?

.deb is first, we'll be adding the others as we figure out their build processes, though `fpm` makes that very easy.
