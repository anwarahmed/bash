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

1. `source /usr/share/omarchy/default/bash/env-bootstrap` — sets `OMARCHY_PATH` and appends the mise-shims / `~/.local/bin` PATH entries. This is the **one** thing that belongs *above* the interactive guard, matching `/etc/skel/.bashrc`: non-interactive shells (`ssh box 'cmd'`, herdr's remote bridge) return before the guard and would otherwise get neither. It only assigns variables and prints nothing, so scp/rsync stay safe.
2. Interactive guard: `[[ $- != *i* ]] && return` — **must stay above the rc source**, and nothing but env assignment may precede it. Everything below it (aliases, the `cli` screen clear, the EXIT trap) breaks scp/rsync/non-interactive ssh if it runs unguarded.
3. `source "${OMARCHY_PATH:-/usr/share/omarchy}/default/bash/rc"` — the Omarchy base layer, which pulls in its own envs, shell opts, aliases, functions, init (mise, starship, zoxide, fzf), and inputrc. Go through `$OMARCHY_PATH`, never a hardcoded path: it is what `omarchy-dev-link` repoints, and `~/.local/share/omarchy` is only a symlink to the real `/usr/share/omarchy`.
4. Local overrides: PATH, `.bash_aliases`, `.bash_functions`, NVM, history settings.
5. `trap ... EXIT` for the goodbye message, then `cli` as the last line.

Two ordering rules fall out of this:

- **Never edit `$OMARCHY_PATH/default/bash/*`.** It is upstream-managed and gets overwritten by Omarchy updates. Override it here instead, after the rc `source` — that is the whole reason the base layer is sourced first. This includes `env-bootstrap`: prefer sourcing it over reimplementing its `OMARCHY_PATH`/`/etc/omarchy.conf` logic inline, so the dev-link behaviour keeps tracking upstream.
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
