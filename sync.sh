#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

green() { printf "\033[32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
blue() { printf "\033[34m%s\033[0m\n" "$1"; }

blue "==> Installing tools..."

if ! command -v claude &>/dev/null; then
  yellow "    Installing Claude Code..."
  npm install -g @anthropic-ai/claude-code 2>/dev/null
fi
green "    ✓ claude code"

if ! command -v codex &>/dev/null; then
  yellow "    Installing Codex..."
  npm install -g @openai/codex 2>/dev/null
fi
green "    ✓ codex"

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

if command -v claude &>/dev/null; then
  claude mcp add --transport http exa https://mcp.exa.ai/mcp 2>/dev/null || true
  green "    ✓ claude exa mcp"
fi

if command -v codex &>/dev/null; then
  codex mcp add exa --url https://mcp.exa.ai/mcp 2>/dev/null || true
  green "    ✓ codex exa mcp"
fi

if ! command -v parallel-cli &>/dev/null; then
  yellow "    Installing parallel-cli..."
  curl -fsSL https://parallel.ai/install.sh | bash 2>/dev/null
fi
green "    ✓ parallel-cli"

if [ ! -f ~/.secrets.zsh ]; then
  cp "$DOTFILES_DIR/shell/secrets.zsh.example" ~/.secrets.zsh
  yellow "    Created ~/.secrets.zsh — fill in your API keys"
else
  green "    ✓ secrets (already exists)"
fi

green "==> Done! Restart your terminal or run: source ~/.zshrc"
