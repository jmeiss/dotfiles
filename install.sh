#!/usr/bin/env bash
# Idempotent setup for macOS and Linux devcontainers.
# VS Code's Dev Containers runs this automatically after cloning the repo into a container.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
OS="$(uname -s)"

log() { printf '[dotfiles] %s\n' "$*"; }

# Move a real file out of the way into the backup dir.
backup() {
  mkdir -p "$BACKUP"
  mv "$1" "$BACKUP/"
  log "backed up $1 -> $BACKUP/"
}

# Symlink a repo file into $HOME, backing up whatever is in the way.
link() {
  local src="$DOTFILES/$1" dest="$2"
  [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]] && return 0
  [[ -e "$dest" || -L "$dest" ]] && backup "$dest"
  ln -s "$src" "$dest"
  log "linked $dest -> $src"
}

# A config file this setup replaces: keep a copy, stop loading it.
retire() {
  [[ -e "$1" && ! -L "$1" ]] && backup "$1"
  return 0
}

# --- zsh + oh-my-zsh + powerlevel10k -------------------------------------------
if ! command -v zsh >/dev/null && [[ "$OS" == Linux ]]; then
  sudo apt-get update -qq && sudo apt-get install -y -qq zsh
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "installing oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

p10k="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
if [[ ! -e "$p10k" ]]; then
  mkdir -p "$(dirname "$p10k")"
  if [[ -d "$HOME/.oh-my-zsh/powerlevel10k" ]]; then
    ln -s "$HOME/.oh-my-zsh/powerlevel10k" "$p10k"
  else
    git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k"
  fi
  log "powerlevel10k ready at $p10k"
fi

link zsh/zshrc "$HOME/.zshrc"
link p10k.zsh "$HOME/.p10k.zsh"

# --- macOS ---------------------------------------------------------------------
if [[ "$OS" == Darwin ]]; then
  link zsh/zprofile "$HOME/.zprofile"
  link bash/bashrc "$HOME/.bashrc"
  link bash/bash_profile "$HOME/.bash_profile"
  retire "$HOME/.profile"  # was only RVM, now in bashrc
  retire "$HOME/.zlogin"   # was only RVM, now in zsh/macos.zsh
fi

# --- Linux (devcontainers) -----------------------------------------------------
if [[ "$OS" == Linux ]]; then
  mkdir -p "$HOME/.local/bin"

  if [[ ! -x "$HOME/.local/bin/claude" ]]; then
    log "installing Claude Code"
    curl -fsSL https://claude.ai/install.sh | bash
  fi

  if [[ ! -x "$HOME/.local/bin/rtk" ]]; then
    case "$(uname -m)" in
      aarch64 | arm64) target=aarch64-unknown-linux-gnu ;;
      x86_64) target=x86_64-unknown-linux-musl ;;
      *) target="" ;;
    esac
    if [[ -n "$target" ]]; then
      log "installing rtk ($target)"
      tmp="$(mktemp -d)"
      curl -fsSL "https://github.com/rtk-ai/rtk/releases/latest/download/rtk-$target.tar.gz" | tar -xz -C "$tmp"
      install -m 0755 "$(find "$tmp" -type f -name rtk | head -1)" "$HOME/.local/bin/rtk"
      rm -rf "$tmp"
    else
      log "no rtk build for $(uname -m); skipping"
    fi
  fi

  # zsh as the login shell too (docker exec, ssh), not only VS Code terminals.
  user="$(id -un)"
  if [[ "$(getent passwd "$user" | cut -d: -f7)" != "$(command -v zsh)" ]] && sudo -n true 2>/dev/null; then
    sudo chsh -s "$(command -v zsh)" "$user"
    log "login shell for $user is now zsh"
  fi
fi

log "done — open a new terminal"
