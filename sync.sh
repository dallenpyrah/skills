#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
VIBEPROXY_APP="/Applications/VibeProxy.app"

green() { printf "\033[32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
blue() { printf "\033[34m%s\033[0m\n" "$1"; }

sync_github_secret() {
  local secret_name="$1"
  local current_value="${!secret_name-}"
  local repo="dallenpyrah/devbox"

  if [ -n "$current_value" ] && [ "$current_value" != "dummy-not-used" ]; then
    return
  fi

  if ! command -v gh &>/dev/null; then
    return
  fi

  local fetched_value
  fetched_value="$(gh secret view "$secret_name" --repo "$repo" 2>/dev/null || true)"

  if [ -n "$fetched_value" ]; then
    export "$secret_name=$fetched_value"
  fi
}

blue "==> Installing tools..."

if ! command -v claude &>/dev/null; then
  yellow "    Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
fi
green "    ✓ claude code"

if ! command -v codex &>/dev/null; then
  yellow "    Installing Codex..."
  brew install --cask codex
fi
green "    ✓ codex"

if ! command -v droid &>/dev/null; then
  yellow "    Installing Droid..."
  curl -fsSL https://factory.ai/install.sh | bash
fi
green "    ✓ droid"

if ! command -v opencode &>/dev/null; then
  yellow "    Installing OpenCode..."
  brew install sst/tap/opencode
fi
green "    ✓ opencode"

if [ ! -d "$VIBEPROXY_APP" ]; then
  yellow "    VibeProxy.app not found in /Applications"
  yellow "    Install it from https://github.com/automazeio/vibeproxy/releases"
else
  green "    ✓ vibeproxy app"
fi

blue "==> Syncing dotfiles to this machine..."

if ! grep -qF "devbox/shell/shared.zsh" ~/.zshrc 2>/dev/null; then
  yellow "    Adding source line to ~/.zshrc"
  echo "" >> ~/.zshrc
  echo "source \"$DOTFILES_DIR/shell/shared.zsh\"" >> ~/.zshrc
fi
green "    ✓ shell config"

if [ -f ~/.secrets.zsh ]; then
  # shellcheck disable=SC1090
  source ~/.secrets.zsh
fi

sync_github_secret PARALLEL_API_KEY
sync_github_secret EXA_API_KEY
sync_github_secret ANTHROPIC_API_KEY
sync_github_secret OPENAI_API_KEY
sync_github_secret CLI_PROXY_API_KEY
sync_github_secret FIREWORKS_API_KEY
sync_github_secret MORPH_API_KEY

cp "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig
green "    ✓ gitconfig"

mkdir -p ~/.claude
cp "$DOTFILES_DIR/claude/settings.json" ~/.claude/settings.json
cp "$DOTFILES_DIR/claude/settings-kimi.json" ~/.claude/settings-kimi.json
cp "$DOTFILES_DIR/claude/settings-codex.json" ~/.claude/settings-codex.json
cp "$DOTFILES_DIR/AGENTS.md" ~/.claude/CLAUDE.md
green "    ✓ claude settings + AGENTS.md + kimi + codex profiles"

mkdir -p ~/.codex
cp "$DOTFILES_DIR/codex/config.toml" ~/.codex/config.toml
cp "$DOTFILES_DIR/AGENTS.md" ~/.codex/AGENTS.md
green "    ✓ codex config + AGENTS.md"

mkdir -p ~/.factory
cp "$DOTFILES_DIR/droid/settings.json" ~/.factory/settings.json
cp "$DOTFILES_DIR/AGENTS.md" ~/.factory/AGENTS.md
green "    ✓ droid settings + AGENTS.md"

mkdir -p ~/.config/opencode
cp "$DOTFILES_DIR/opencode/opencode.json" ~/.config/opencode/opencode.json
cp "$DOTFILES_DIR/AGENTS.md" ~/.config/opencode/AGENTS.md
green "    ✓ opencode config + AGENTS.md"

# Set OPENCODE_MESSAGE_QUEUE_MODE globally for all processes
launchctl setenv OPENCODE_MESSAGE_QUEUE_MODE hold 2>/dev/null || true
export OPENCODE_MESSAGE_QUEUE_MODE=hold

launchctl setenv OPENCODE_EXPERIMENTAL_PLAN_MODE true 2>/dev/null || true
export OPENCODE_EXPERIMENTAL_PLAN_MODE=true

if command -v bunx &>/dev/null; then
  bunx @0xsero/open-queue 2>/dev/null || true
  green "    ✓ open-queue plugin"
elif command -v npx &>/dev/null; then
  npx @0xsero/open-queue 2>/dev/null || true
  green "    ✓ open-queue plugin"
else
  yellow "    ⚠ open-queue: needs bun or node to install"
fi

mkdir -p ~/.config/ghostty
cp "$DOTFILES_DIR/ghostty/config" ~/.config/ghostty/config
green "    ✓ ghostty config"

if command -v claude &>/dev/null; then
  claude mcp add --transport http exa https://mcp.exa.ai/mcp 2>/dev/null || true
  green "    ✓ claude exa mcp"
  claude mcp add morph-mcp --scope user -e MORPH_API_KEY="${MORPH_API_KEY-}" -- npx -y @morphllm/morphmcp 2>/dev/null || true
  green "    ✓ claude morph mcp"
fi

if command -v codex &>/dev/null; then
  codex mcp add exa --url https://mcp.exa.ai/mcp 2>/dev/null || true
  green "    ✓ codex exa mcp"
  codex mcp add morph-mcp --env MORPH_API_KEY="${MORPH_API_KEY-}" -- npx -y @morphllm/morphmcp 2>/dev/null || true
  green "    ✓ codex morph mcp"
fi

if command -v droid &>/dev/null; then
  droid mcp add exa https://mcp.exa.ai/mcp --type http 2>/dev/null || true
  green "    ✓ droid exa mcp"
  droid mcp add morph-mcp -- npx -y @morphllm/morphmcp --env MORPH_API_KEY="${MORPH_API_KEY-}" 2>/dev/null || true
  green "    ✓ droid morph mcp"
fi

if command -v droid &>/dev/null; then
  droid plugin marketplace add https://github.com/parallel-web/parallel-agent-skills 2>/dev/null || true
  droid plugin install parallel@parallel-agent-skills 2>/dev/null || true
  green "    ✓ droid parallel plugin"
fi

if command -v codex &>/dev/null; then
  codex /plugins 2>/dev/null <<'EOF' || true
/quit
EOF
  green "    ✓ codex plugin config ready"
fi

if [ -d "$VIBEPROXY_APP" ]; then
  open -gj "$VIBEPROXY_APP" 2>/dev/null || true
  green "    ✓ vibeproxy launched"
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

cat > ~/.secrets.zsh <<EOF
export PARALLEL_API_KEY="${PARALLEL_API_KEY-}"
export EXA_API_KEY="${EXA_API_KEY-}"
export ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY-}"
export OPENAI_API_KEY="${OPENAI_API_KEY-}"
export CLI_PROXY_API_KEY="${CLI_PROXY_API_KEY-dummy-not-used}"
export FIREWORKS_API_KEY="${FIREWORKS_API_KEY-}"
export MORPH_API_KEY="${MORPH_API_KEY-}"
export OPENCODE_MESSAGE_QUEUE_MODE="${OPENCODE_MESSAGE_QUEUE_MODE:-hold}"
export OPENCODE_EXPERIMENTAL_PLAN_MODE="${OPENCODE_EXPERIMENTAL_PLAN_MODE:-true}"
EOF
green "    ✓ synced ~/.secrets.zsh"

yellow "    Manual one-time setup:"
yellow "      1. Open VibeProxy settings and connect ChatGPT/Codex and Claude/Anthropic"
yellow "      2. Restart Droid and OpenCode after credentials are available"
yellow "      3. In OpenCode, run /connect and add fireworks.ai if provider auth is not already present"
yellow "      4. Select a custom model from /model or use OpenCode's configured Fireworks default"

green "==> Done! Restart your terminal or run: source ~/.zshrc"
