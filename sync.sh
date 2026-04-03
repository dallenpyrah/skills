#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
REMOTE="dallenitt"

# --- Colors ---
green() { printf "\033[32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
blue() { printf "\033[34m%s\033[0m\n" "$1"; }

# --- Usage ---
usage() {
  echo "Usage: ./sync.sh [local|remote|both|pull]"
  echo ""
  echo "  local   - Apply configs to this machine"
  echo "  remote  - Push configs to $REMOTE"
  echo "  both    - Apply to both (default)"
  echo "  pull    - Pull configs from $REMOTE into this repo"
  echo ""
}

# --- Apply configs locally ---
sync_local() {
  blue "==> Syncing to local machine..."

  # Shell: add source line to .zshrc if not already there
  SOURCE_LINE="source \"$DOTFILES_DIR/shell/shared.zsh\""
  if ! grep -qF "$DOTFILES_DIR/shell/shared.zsh" ~/.zshrc 2>/dev/null; then
    yellow "    Adding source line to ~/.zshrc"
    echo "" >> ~/.zshrc
    echo "# -- Dotfiles --" >> ~/.zshrc
    echo "$SOURCE_LINE" >> ~/.zshrc
  fi

  # Git
  cp "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig
  green "    ✓ gitconfig"

  # Claude Code
  mkdir -p ~/.claude
  cp "$DOTFILES_DIR/claude/settings.json" ~/.claude/settings.json
  green "    ✓ claude settings"

  # Codex
  mkdir -p ~/.codex
  cp "$DOTFILES_DIR/codex/config.toml" ~/.codex/config.toml
  green "    ✓ codex config"

  green "==> Local sync complete!"
}

# --- Push configs to remote ---
sync_remote() {
  blue "==> Syncing to $REMOTE..."

  # Shell: copy shared files and add source line
  ssh "$REMOTE" "mkdir -p ~/dotfiles/shell"
  scp -q "$DOTFILES_DIR/shell/shared.zsh" "$DOTFILES_DIR/shell/aliases.zsh" "$REMOTE":~/dotfiles/shell/
  ssh "$REMOTE" "grep -qF 'dotfiles/shell/shared.zsh' ~/.zshrc 2>/dev/null || (echo '' >> ~/.zshrc && echo '# -- Dotfiles --' >> ~/.zshrc && echo 'source ~/dotfiles/shell/shared.zsh' >> ~/.zshrc)"
  green "    ✓ shell config"

  # Git
  scp -q "$DOTFILES_DIR/git/gitconfig" "$REMOTE":~/.gitconfig
  green "    ✓ gitconfig"

  # Claude Code
  ssh "$REMOTE" "mkdir -p ~/.claude"
  scp -q "$DOTFILES_DIR/claude/settings.json" "$REMOTE":~/.claude/settings.json
  green "    ✓ claude settings"

  # Codex
  ssh "$REMOTE" "mkdir -p ~/.codex"
  scp -q "$DOTFILES_DIR/codex/config.toml" "$REMOTE":~/.codex/config.toml
  green "    ✓ codex config"

  green "==> Remote sync complete!"
}

# --- Pull configs from remote into repo ---
pull_remote() {
  blue "==> Pulling configs from $REMOTE into repo..."

  scp -q "$REMOTE":~/.claude/settings.json "$DOTFILES_DIR/claude/settings.json"
  green "    ✓ claude settings"

  scp -q "$REMOTE":~/.codex/config.toml "$DOTFILES_DIR/codex/config.toml"
  green "    ✓ codex config"

  scp -q "$REMOTE":~/.gitconfig "$DOTFILES_DIR/git/gitconfig"
  green "    ✓ gitconfig"

  green "==> Pull complete! Review changes with: git -C $DOTFILES_DIR diff"
}

# --- Main ---
case "${1:-both}" in
  local)  sync_local ;;
  remote) sync_remote ;;
  both)   sync_local; echo ""; sync_remote ;;
  pull)   pull_remote ;;
  *)      usage ;;
esac
