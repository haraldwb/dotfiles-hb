# dotfiles-hb

My dotfiles, managed with [chezmoi](https://www.chezmoi.io/).
Source of truth is `~/.local/share/chezmoi`; `~` is generated from it.

## Contents
- zsh config (`.zshrc`, `.zshenv`)
- tmux config — omarchy keybindings, see [the manual](https://omarchy.org/manual/hotkeys/#tmux)
- Neovim config (LazyVim)
- `.xprofile` — swaps Caps/Escape on X startup

## Machine-local values (not in this repo)

Private variables are stored in **`~/.config/zsh/local.zsh`** — mode 600,
untracked, and outside every git work tree. This repo is public, so anything
private or machine-specific lives there rather than here.

`.zshenv` loads it if present, and only this guard is committed:

```zsh
if [[ -f ~/.config/zsh/local.zsh ]]; then
  source ~/.config/zsh/local.zsh
fi
```

Three details that are easy to get wrong later:

- It lives in **`.zshenv`, not `.zshrc`** — only interactive shells read
  `.zshrc`, so scripts, cron jobs and agent tool-calls saw an empty variable
  until it moved.
- Use **`export NAME="value"`**, not bare dotenv `NAME=value`. zsh cannot
  source an unquoted value containing spaces: it fails with
  `command not found` and silently sets the variable to empty. Quote
  everything.
- An **`if` block, not `&&`** — as the last line of `.zshenv`, a false `&&`
  leaves every shell starting at `$? = 1` on machines without the file.

Also unmanaged on purpose: **symlinks whose target is machine-local**.
chezmoi stores a symlink's target string in the source repo, so managing one
publishes the path just as surely as committing the variable would.

Nothing here is backed up, by design — recreate it per machine.

## Per-machine scoping

`.chezmoiignore` is a template keyed on `.chezmoi.kernel.osrelease`, so files
apply only where they make sense. Deliberately **not** keyed on hostname,
which is neither portable nor safe to publish.

| File | Skipped on |
| --- | --- |
| `.xprofile` | WSL — no `setxkbmap`, and nothing reads it there |
| `.config/tmux/local.conf` | everywhere but WSL — it is a WezTerm terminal-feature shim |
| `README.md` | always — documents the repo, not a dotfile |
