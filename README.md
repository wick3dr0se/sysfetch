<div align="center">
<h1>sysfetch</h1>
<p>A super tiny *nix system information fetch script written in BASH</p>
<img src="https://github.com/wick3dr0se/sysfetch/blob/master/screen.png"></img>

<img src="https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white"></img>
<img src="https://img.shields.io/badge/Made%20with-Bash-1f425f.svg"></img>
<img src=https://img.shields.io/badge/Maintained%3F-yes-green.svg></img>
<img src="https://badge-size.herokuapp.com/wick3dr0se/sysfetch/master/sysfetch"></img>
</div>

## Installing from package manager:
#### Arch Linux -
&ensp;sysfetch is installable from the AUR as `sysfetch-git`

#### How to Use:
run `sysfetch`

## Pulling sysfetch from GitHub:
Clone the repository

**#**&ensp; `git clone -b master --single-branch https://github.com/wick3dr0se/sysfetch`

Change directory into the folder

**#**&ensp; `cd sysfetch`

Make script executable

**#**&ensp; `chmod a+rx sysfetch`

Execute script

**#**&ensp; `./sysfetch` or `bash sysfetch`


## Debugging:
Comment out `exec 2>/dev/null` to output all errors in terminal

## Contributing:
Fork this repository, then clone this branch from your fork

&ensp;**#** `git clone -b alpha --single-branch https://github.com/<user>/sysfetch alpha_sysfetch`

Stage and commit your changes with a relevant message and link to issue # if fix, like:

&ensp;**#** `git add .`

&ensp;**#** `git commit -m "test; fix issue #3"`

Push your changes and then create a pull request to merge from your branch to this repositorys alpha branch

&ensp;**#** `git push`

## Testing:
Individual scripts should be pushed to the gamma branch and any PR's to existing code should be made to alpha branch so we can test everything properly before merging to master. Scripts in gamma branch need proper testing, clean code and output to move to alpha

## Communication:
Join us on discord: https://discord.gg/TstuWvDzXr
