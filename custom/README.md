# Custom functions and aliases

This folder is for your own functions and aliases that are **not** maintained
by this repo. Everything in here except this README is gitignored, so your
files stay local to this machine and never conflict with updates to the repo.

## Adding your own

1. Create a file in this folder whose name ends in `.sh`, e.g.
   `~/.config/bash/custom/work.sh`. Split things across as many files as you
   like — group them by topic (`git.sh`, `docker.sh`, `work.sh`, ...).
2. Start it with `#!/bin/bash` (the files are sourced, not executed, so it does
   not need to be executable).
3. Add your aliases and functions:

   ```bash
   #!/bin/bash

   # Aliases
   alias k='kubectl'

   # Jump to a project directory by name
   proj() {
     cd ~/projects/"$1" || return
   }
   ```

4. Open a new terminal. The file is picked up automatically — there is no
   install step.

## How it is loaded

`.bashrc` sources every `custom/*.sh` file, in alphabetical order, on each
interactive shell start. They load **after** the Omarchy defaults and this
repo's `.bash_aliases` / `.bash_functions`, so anything defined here wins and
can override an existing alias or function of the same name. If one file
depends on another, prefix names to control the order (`10-base.sh`,
`20-work.sh`).

Files that do not end in `.sh` (like this README) are ignored.

## Tips

- **Don't print anything.** The screen is cleared at the end of `.bashrc`, so
  any output from these files is wiped before you see it.
- **Guard optional tools**, so the shell still starts on a machine without
  them:

  ```bash
  command -v kubectl >/dev/null && source <(kubectl completion bash)
  ```

- **Check syntax** after editing, before opening a new terminal:

  ```bash
  bash -n ~/.config/bash/custom/work.sh
  ```

- **Inspect a function** without starting a new shell:

  ```bash
  source ~/.config/bash/custom/work.sh && declare -f proj
  ```

- To disable a file temporarily, rename it so it no longer ends in `.sh`
  (e.g. `work.sh.off`).
