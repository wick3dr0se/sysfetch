<div align="center">
<h1>sysfetch alpha</h1>
<img src="https://github.com/wick3dr0se/fetch.sh/blob/alpha/screen.png"></img>

<img src="https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white"></img>
<img src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg"></img>
<img src=https://img.shields.io/badge/Maintained%3F-yes-green.svg></img>
<img src="https://badge-size.herokuapp.com/wick3dr0se/fetch.sh/alpha/fetch.sh"></img>
</div>

### Debugging:
Comment out `exec 2>/dev/null` to output all errors in terminal

## Contributing:
Fork this repository, then clone this branch from your fork

&ensp;**#** `git clone -b alpha --single-branch https://github.com/<user>/sysfetch alpha_sysfetch`

Stage and commit your changes with a relevant message and link to issue # if fix, like:

&ensp;**#** `git add .`

&ensp;**#** `git commit -m "test; fix issue #3"`

Push your changes and then create a pull request to merge from your branch to this repositorys alpha branch

&ensp;**#** `git push`

#### Communication Channels:
Join us on discord: https://discord.gg/TstuWvDzXr

Or open an [Issue](https://github.com/wick3dr0se/sysfetch/issues), we're always happy to have more feedback or ideas.

--------------

#### Installation:

sysfetch can be run simply be cloned and ran in place:

&ensp;**#** `git clone -b alpha --single-branch https://github.com/<user>/sysfetch alpha_sysfetch`

&ensp;**#** `cd /alpha_sysfetch`

&ensp;**#** `./sysfetch`

*OR*

&ensp;**#** `bash sysfetch`


It can be installed via makefile:

&ensp;**#** `cd /alpha_sysfetch`

&ensp;**#** `sudo make install`

#### Removal:

if downloaded via `git clone` simply:

&ensp;**#** `rm -rf alpha_sysfetch` while in the directory it was cloned to.

If installed via makefile:

&ensp;**#** `cd /alpha_sysfetch`

&ensp;**#** `sudo make uninstall`

--------------

## Testing:
For individual scripts that need further testing or are possible implementations. Generally most things tested in this branch will be new scripts that are located in the components folder.

&ensp;**#** `git clone -b gamma --single-branch https://github.com/<user>/sysfetch gamma_sysfetch`

Repeat the commands from [Contributing](#Contributing:) above, however in gamma branch feel free to add your own scripts that could be merged into the alpha branch after testing on at least two operating systems. (Different linuxes or VM's are fine.)

Test commands and output and communicate with us on Discord if you need assistance, or are unsure of something.
