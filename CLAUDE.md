# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal Bash configuration for an Omarchy (Arch Linux) machine. There is no build, no test suite, and no package manager — the "artifact" is the interactive shell itself. Changes are live: this directory *is* the deployed config, reached through symlinks in `$HOME`.

## Deployment model

Only three files are symlinked into `$HOME` (see `README.md`):

```
~/.bashrc       -> ~/.config/bash/.bashrc
~/.bash_profile -> ~/.config/bash/.bash_profile
~/.bash_logout  -> ~/.config/bash/.bash_logout
```

`.bash_aliases`, `.bash_functions`, and `.bash_goodbye_message` are **not** symlinked — `.bashrc` sources them by absolute path (`~/.config/bash/...`). Consequence: a new file added to this repo does nothing until something explicitly sources it, and editing any of these files takes effect in the next shell with no install step.

## Load order

`.bash_profile` → `.bashrc` (preferring the repo copy over `~/.bashrc`) → then, inside `.bashrc`:

1. Interactive guard: `[[ $- != *i* ]] && return` — **must stay the first statement**. Everything below it (aliases, the `cli` screen clear, the EXIT trap) breaks scp/rsync/non-interactive ssh if it runs unguarded.
2. `source ~/.local/share/omarchy/default/bash/rc` — the Omarchy base layer, which pulls in its own envs, shell opts, aliases, functions, init (mise, starship, zoxide, fzf), and inputrc.
3. Local overrides: PATH, `.bash_aliases`, `.bash_functions`, NVM, history settings.
4. `trap ... EXIT` for the goodbye message, then `cli` as the last line.

Two ordering rules fall out of this:

- **Never edit `~/.local/share/omarchy/default/bash/*`.** It is upstream-managed and gets overwritten by Omarchy updates. Override it here instead, after the `source` on line 8 — that is the whole reason the base layer is sourced first.
- **`cli` clears the screen at the end of `.bashrc`.** Anything printed by earlier lines is wiped. Put new output *after* the `cli` call, or it will never be seen.

## History

`.bashrc` redirects `HISTFILE` into this repo (`~/.config/bash/.bash_history`). The file is gitignored but sits in the working tree, so it shows up in `ls` and in shell globs here. Do not read it, commit it, or un-ignore it.

## Verifying a change

There is no linter installed (no `shellcheck`, no `shfmt`). The available checks:

```sh
bash -n .bashrc              # syntax-only parse; run on any file you edit
bash -i -c 'exit'            # full interactive startup, exercises the EXIT trap
env -i bash -c 'echo ok'     # confirms the non-interactive guard still short-circuits
source ~/.config/bash/.bash_functions && declare -f <name>   # inspect a function without a new shell
```

Prefer opening a fresh terminal over `source ~/.bashrc` in a live shell — re-sourcing stacks a second EXIT trap and re-runs `cli`.

## `clear-system-cache`

The one destructive function in the repo (`.bash_functions`). It runs `sudo pacman -Scc`, `pacman -Rns` on orphans, the `yay` equivalents, and `rm -rf ~/.cache/*`, then lists Snapper snapshots. Snapshot deletion is deliberately left manual. Do not run it to test edits — syntax-check the function instead.

## Commits

Every change lands on `main` via a PR to `github.com/anwarahmed/bash`. Commit subjects are lowercase, past-tense or descriptive, with the PR number appended:

```
removed dead .bash_login and guarded nvm source (#25)
added new function clear-system-cache (#23)
```

## Conventions

- Every file starts with `#!/bin/bash` even though all of them are sourced, never executed.
- Aliases are grouped by topic in `.bash_aliases` with a comment header per group; git aliases are alphabetized.
- Functions carry a comment block above them; `clear-system-cache` documents each step and its requirements — match that depth for anything non-obvious.
- Guard sources of optional external files, e.g. `[ -f /usr/share/nvm/init-nvm.sh ] && source ...`, so the shell still starts on a machine without them.
