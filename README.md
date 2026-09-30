# Bash

https://www.gnu.org/software/bash/

My Bash Setup

## Files

Copy the contents of this repository to `~/.config/bash/`.
The following files can be ignored:

- `README.md`
- `.git`
- `.gitignore`

## Symlinks

Create symbolic links for the files below to the home directory. Make a backup of any existing files in the home directory first before making the links.

- `.bashrc`
- `.bash_profile`
- `.bash_logout`

```sh
ln -s ~/.config/bash/.bashrc ~/.bashrc
ln -s ~/.config/bash/.bash_profile ~/.bash_profile
ln -s ~/.config/bash/.bash_logout ~/.bash_logout
```

## Custom functions and aliases

Put your own functions and aliases in `~/.config/bash/custom/*.sh`. They are loaded automatically and are not tracked by this repo. See [`custom/README.md`](custom/README.md) for details.
