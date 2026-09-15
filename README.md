# dotfiles

Shell setup shared by my Mac and every VS Code devcontainer: zsh + oh-my-zsh + powerlevel10k, git aliases, and (in containers) Claude Code and rtk.

## Layout

| Path | Loaded by | Purpose |
| --- | --- | --- |
| `zsh/zshrc` | `~/.zshrc` | oh-my-zsh, prompt, then the files below |
| `zsh/aliases.zsh`, `zsh/functions.zsh` | zshrc | git aliases and helpers (all machines) |
| `zsh/macos.zsh` | zshrc on macOS | PATH for nvm, bun, RVM, Java; Claude config profiles |
| `zsh/linux.zsh` | zshrc on Linux | `~/.local/bin` (claude, rtk) |
| `zsh/zprofile` | `~/.zprofile` | Homebrew + `~/.local/bin` for login shells |
| `bash/` | `~/.bashrc`, `~/.bash_profile` (macOS) | minimal bash fallback |
| `p10k.zsh` | `~/.p10k.zsh` | powerlevel10k layout |

Secrets and per-machine tweaks go in `~/.zshrc.local` / `~/.bashrc.local`. They are sourced last and never committed.

## Install

```sh
git clone git@github.com:jmeiss/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

The script is idempotent. Anything it replaces is moved to `~/.dotfiles-backup/<timestamp>/`, never deleted.

## Devcontainers

VS Code user settings:

```jsonc
"terminal.integrated.defaultProfile.linux": "zsh",
"dotfiles.repository": "jmeiss/dotfiles",
"dotfiles.targetPath": "~/dotfiles",
"dotfiles.installCommand": "install.sh"
```

Dev Containers clones the repo and runs `install.sh` whenever it creates a container. In an already-running container, run `~/dotfiles/install.sh` once by hand, or rebuild the container.

## Notes

- `p10k configure` rewrites `~/.p10k.zsh` in place of the symlink. Copy the result back into `p10k.zsh` and rerun `install.sh`.
