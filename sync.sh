#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

green() { printf "\033[32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
blue() { printf "\033[34m%s\033[0m\n" "$1"; }

blue "==> Syncing dotfiles to this machine..."

if ! grep -qF "dotfiles/shell/shared.zsh" ~/.zshrc 2>/dev/null; then
  yellow "    Adding source line to ~/.zshrc"
  echo "" >> ~/.zshrc
  echo "source \"$DOTFILES_DIR/shell/shared.zsh\"" >> ~/.zshrc
fi
green "    ✓ shell config"

cp "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig
green "    ✓ gitconfig"

mkdir -p ~/.claude
cp "$DOTFILES_DIR/claude/settings.json" ~/.claude/settings.json
green "    ✓ claude settings"

mkdir -p ~/.codex
cp "$DOTFILES_DIR/codex/config.toml" ~/.codex/config.toml
green "    ✓ codex config"

green "==> Done! Restart your terminal or run: source ~/.zshrc"
