#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$HOME/.config"

link() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  backup: $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "  linked: $dst -> $src"
}

echo "==> Linking dotfiles..."
link "$DOTFILES/nvim"              "$CONFIG/nvim"
link "$DOTFILES/wezterm"           "$CONFIG/wezterm"
link "$DOTFILES/starship/starship.toml" "$CONFIG/starship.toml"
mkdir -p "$CONFIG/herdr"
link "$DOTFILES/herdr/config.toml" "$CONFIG/herdr/config.toml"

echo "==> Done."
