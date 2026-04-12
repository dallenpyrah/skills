#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
VIBEPROXY_APP="/Applications/VibeProxy.app"
INFISICAL_ENV="${1:-dev}"

green() { printf "\033[32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
blue() { printf "\033[34m%s\033[0m\n" "$1"; }
red() { printf "\033[31m%s\033[0m\n" "$1"; }

# ─── 1. Prerequisites ───────────────────────────────────────────────────────

blue "==> Checking prerequisites..."

if ! command -v brew &>/dev/null; then
  yellow "    Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null || true)"
fi
green "    ✓ homebrew"

if ! command -v gh &>/dev/null; then
  yellow "    Installing GitHub CLI..."
  brew install gh
fi
if ! gh auth status &>/dev/null 2>&1; then
  red "    ✗ gh not authenticated. Run: gh auth login"
  red "      Then re-run sync.sh"
  exit 1
fi
green "    ✓ gh (authenticated)"

if ! command -v bun &>/dev/null && ! command -v node &>/dev/null; then
  yellow "    Installing bun (provides node runtime)..."
  brew install oven-sh/bun/bun
fi
green "    ✓ bun/node"

# ─── 2. Infisical — pull secrets ────────────────────────────────────────────

blue "==> Pulling secrets from Infisical..."

if ! command -v infisical &>/dev/null; then
  yellow "    Installing Infisical CLI..."
  brew install infisical
else
  brew upgrade infisical 2>/dev/null || true
fi
green "    ✓ infisical cli"

# Check that this project is linked to Infisical
if [ ! -f "$DOTFILES_DIR/.infisical.json" ]; then
  red "    ✗ .infisical.json not found — run: infisical init"
  red "      Then re-run sync.sh"
  exit 1
fi

# Pull all secrets for the given environment into .env
# This uses the .infisical.json in this directory for project ID + default env
INFISICAL_API_URL="${INFISICAL_API_URL:-https://infisical-production-a65a.up.railway.app}" \
  infisical export --env="$INFISICAL_ENV" --format=dotenv-export > "$DOTFILES_DIR/.env"
green "    ✓ secrets pulled (env: $INFISICAL_ENV)"

# Source the .env so all secrets are available as env vars for the rest of the script
set -a
# shellcheck disable=SC1091
source "$DOTFILES_DIR/.env"
set +a

# ─── 3. Install / update tools ──────────────────────────────────────────────

blue "==> Installing/updating tools..."

brew_install_or_upgrade() {
  local formula="$1"
  if brew list --formula 2>/dev/null | grep -q "^${formula}$"; then
    brew upgrade "$formula" 2>/dev/null || true
  else
    brew install "$formula"
  fi
}

brew_cask_install_or_upgrade() {
  local cask="$1"
  if brew list --cask 2>/dev/null | grep -q "^${cask}$"; then
    brew upgrade --cask "$cask" 2>/dev/null || true
  else
    brew install --cask "$cask"
  fi
}

# Claude Code
if ! command -v claude &>/dev/null; then
  yellow "    Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  claude update 2>/dev/null || true
fi
green "    ✓ claude code"

# Codex
brew_cask_install_or_upgrade codex
green "    ✓ codex"

# Droid
if ! command -v droid &>/dev/null; then
  yellow "    Installing Droid..."
  curl -fsSL https://factory.ai/install.sh | bash
else
  droid update 2>/dev/null || true
fi
green "    ✓ droid"

# OpenCode
brew_install_or_upgrade sst/tap/opencode
green "    ✓ opencode"

# VibeProxy — auto-download latest from GitHub releases
if [ ! -d "$VIBEPROXY_APP" ]; then
  yellow "    Downloading VibeProxy latest release..."
  VIBEPROXY_URL="$(curl -fsSL "https://api.github.com/repos/automazeio/vibeproxy/releases/latest" \
    | grep -m1 '"browser_download_url":.*\.dmg"' \
    | sed -E 's/.*"browser_download_url": *"([^"]+)".*/\1/')"
  if [ -n "$VIBEPROXY_URL" ]; then
    TMPFILE="$(mktemp /tmp/vibeproxy-XXXXXX.dmg)"
    curl -fSL -o "$TMPFILE" "$VIBEPROXY_URL"
    hdiutil attach "$TMPFILE" -quiet -nobrowse
    cp -R "/Volumes/VibeProxy/VibeProxy.app" /Applications/ 2>/dev/null || true
    hdiutil detach "/Volumes/VibeProxy" -quiet 2>/dev/null || true
    rm -f "$TMPFILE"
    green "    ✓ vibeproxy (installed)"
  else
    yellow "    ⚠ Could not find VibeProxy .dmg in latest release"
  fi
else
  green "    ✓ vibeproxy (installed)"
fi

# Shelf
if ! command -v shelf &>/dev/null; then
  yellow "    Installing shelf..."
  bun install -g @rikalabs/shelf 2>/dev/null || npm install -g @rikalabs/shelf 2>/dev/null || true
else
  bun update -g @rikalabs/shelf 2>/dev/null || npm update -g @rikalabs/shelf 2>/dev/null || true
fi
green "    ✓ shelf"

# Parallel CLI
if ! command -v parallel-cli &>/dev/null; then
  yellow "    Installing parallel-cli..."
  curl -fsSL https://parallel.ai/install.sh | bash 2>/dev/null
else
  parallel-cli update 2>/dev/null || true
fi
green "    ✓ parallel-cli"

# ─── 4. Sync dotfiles ───────────────────────────────────────────────────────

blue "==> Syncing dotfiles to this machine..."

# Shell config
if ! grep -qF "devbox/shell/shared.zsh" ~/.zshrc 2>/dev/null; then
  yellow "    Adding source line to ~/.zshrc"
  echo "" >> ~/.zshrc
  echo "source \"$DOTFILES_DIR/shell/shared.zsh\"" >> ~/.zshrc
fi
green "    ✓ shell config"

# Git config
cp "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig
green "    ✓ gitconfig"

# Claude
mkdir -p ~/.claude
cp "$DOTFILES_DIR/claude/settings.json" ~/.claude/settings.json
cp "$DOTFILES_DIR/claude/settings-kimi.json" ~/.claude/settings-kimi.json
cp "$DOTFILES_DIR/claude/settings-codex.json" ~/.claude/settings-codex.json
cp "$DOTFILES_DIR/AGENTS.md" ~/.claude/CLAUDE.md
green "    ✓ claude settings + AGENTS.md + kimi + codex profiles"

# Codex
mkdir -p ~/.codex
cp "$DOTFILES_DIR/codex/config.toml" ~/.codex/config.toml
cp "$DOTFILES_DIR/AGENTS.md" ~/.codex/AGENTS.md
green "    ✓ codex config + AGENTS.md"

# Droid
mkdir -p ~/.factory
cp "$DOTFILES_DIR/droid/settings.json" ~/.factory/settings.json
cp "$DOTFILES_DIR/AGENTS.md" ~/.factory/AGENTS.md
mkdir -p ~/.factory/droids
cp "$DOTFILES_DIR"/droid/droids/*.md ~/.factory/droids/
mkdir -p ~/.factory/skills
cp -r "$DOTFILES_DIR"/droid/skills/* ~/.factory/skills/
rm -f ~/.factory/config.json  # legacy

# Generate settings.local.json with resolved API keys from Infisical.
# IDs/indices must exactly mirror droid/settings.json — sessionDefaultSettings
# references these IDs, and a mismatch silently breaks the default model.
cat > ~/.factory/settings.local.json <<LOCALEOF
{
  "customModels": [
    {
      "model": "accounts/fireworks/routers/kimi-k2p5-turbo",
      "id": "custom:Kimi-K2.5-Turbo-[Fireworks]-0",
      "index": 0,
      "baseUrl": "https://api.fireworks.ai/inference/v1",
      "apiKey": "${FIREWORKS_API_KEY}",
      "displayName": "Kimi K2.5 Turbo [Fireworks]",
      "maxOutputTokens": 256000,
      "noImageSupport": false,
      "provider": "generic-chat-completion-api"
    },
    {
      "model": "gpt-5.4(high)",
      "id": "custom:GPT-5.4-High-[ChatGPT-Pro]-1",
      "index": 1,
      "baseUrl": "http://localhost:8317/v1",
      "apiKey": "${CLI_PROXY_API_KEY}",
      "displayName": "GPT-5.4 High [ChatGPT Pro]",
      "noImageSupport": false,
      "provider": "openai"
    },
    {
      "model": "claude-opus-4-6",
      "id": "custom:Claude-Opus-4.6-Thinking-High-[Anthropic-Max]-2",
      "index": 2,
      "baseUrl": "http://localhost:8317",
      "apiKey": "${CLI_PROXY_API_KEY}",
      "displayName": "Claude Opus 4.6 Thinking High [Anthropic Max]",
      "noImageSupport": false,
      "provider": "anthropic"
    },
    {
      "model": "claude-sonnet-4-6",
      "id": "custom:Claude-Sonnet-4.6-Thinking-High-[Anthropic-Max]-3",
      "index": 3,
      "baseUrl": "http://localhost:8317",
      "apiKey": "${CLI_PROXY_API_KEY}",
      "displayName": "Claude Sonnet 4.6 Thinking High [Anthropic Max]",
      "noImageSupport": false,
      "provider": "anthropic"
    },
    {
      "model": "gpt-5.4(xhigh)",
      "id": "custom:GPT-5.4-XHigh-[ChatGPT-Pro]-4",
      "index": 4,
      "baseUrl": "http://localhost:8317/v1",
      "apiKey": "${CLI_PROXY_API_KEY}",
      "displayName": "GPT-5.4 XHigh [ChatGPT Pro]",
      "noImageSupport": false,
      "provider": "openai"
    },
    {
      "model": "gpt-5.4(medium)",
      "id": "custom:GPT-5.4-Medium-[ChatGPT-Pro]-5",
      "index": 5,
      "baseUrl": "http://localhost:8317/v1",
      "apiKey": "${CLI_PROXY_API_KEY}",
      "displayName": "GPT-5.4 Medium [ChatGPT Pro]",
      "noImageSupport": false,
      "provider": "openai"
    },
    {
      "model": "gpt-5.4(low)",
      "id": "custom:GPT-5.4-Low-[ChatGPT-Pro]-6",
      "index": 6,
      "baseUrl": "http://localhost:8317/v1",
      "apiKey": "${CLI_PROXY_API_KEY}",
      "displayName": "GPT-5.4 Low [ChatGPT Pro]",
      "noImageSupport": false,
      "provider": "openai"
    },
    {
      "model": "gpt-5.3-codex(xhigh)",
      "id": "custom:GPT-5.3-Codex-XHigh-[ChatGPT-Pro]-7",
      "index": 7,
      "baseUrl": "http://localhost:8317/v1",
      "apiKey": "${CLI_PROXY_API_KEY}",
      "displayName": "GPT-5.3 Codex XHigh [ChatGPT Pro]",
      "noImageSupport": false,
      "provider": "openai"
    },
    {
      "model": "claude-opus-4-5-20251101",
      "id": "custom:Claude-Opus-4.5-[Anthropic-Max]-8",
      "index": 8,
      "baseUrl": "http://localhost:8317",
      "apiKey": "${CLI_PROXY_API_KEY}",
      "displayName": "Claude Opus 4.5 [Anthropic Max]",
      "noImageSupport": false,
      "provider": "anthropic"
    },
    {
      "model": "claude-sonnet-4-5-20250929",
      "id": "custom:Claude-Sonnet-4.5-[Anthropic-Max]-9",
      "index": 9,
      "baseUrl": "http://localhost:8317",
      "apiKey": "${CLI_PROXY_API_KEY}",
      "displayName": "Claude Sonnet 4.5 [Anthropic Max]",
      "noImageSupport": false,
      "provider": "anthropic"
    },
    {
      "model": "claude-haiku-4-5-20251001",
      "id": "custom:Claude-Haiku-4.5-[Anthropic-Max]-10",
      "index": 10,
      "baseUrl": "http://localhost:8317",
      "apiKey": "${CLI_PROXY_API_KEY}",
      "displayName": "Claude Haiku 4.5 [Anthropic Max]",
      "noImageSupport": false,
      "provider": "anthropic"
    }
  ]
}
LOCALEOF
green "    ✓ droid settings + AGENTS.md + droids + skills + local config"

# OpenCode
mkdir -p ~/.config/opencode
cp "$DOTFILES_DIR/opencode/opencode.json" ~/.config/opencode/opencode.json
cp "$DOTFILES_DIR/AGENTS.md" ~/.config/opencode/AGENTS.md
green "    ✓ opencode config + AGENTS.md"

# Ghostty
mkdir -p ~/.config/ghostty
cp "$DOTFILES_DIR/ghostty/config" ~/.config/ghostty/config
green "    ✓ ghostty config"

# ─── 5. MCP integrations ───────────────────────────────────────────────────

blue "==> Setting up MCP integrations..."

if command -v claude &>/dev/null; then
  claude mcp add --transport http exa https://mcp.exa.ai/mcp 2>/dev/null || true
  green "    ✓ claude mcp (exa)"
fi

if command -v codex &>/dev/null; then
  codex mcp add exa --url https://mcp.exa.ai/mcp 2>/dev/null || true
  green "    ✓ codex mcp (exa)"
fi

if command -v droid &>/dev/null; then
  droid mcp add exa https://mcp.exa.ai/mcp --type http 2>/dev/null || true
  green "    ✓ droid mcp (exa)"
fi

# ─── 6. Plugins & extras ────────────────────────────────────────────────────

blue "==> Setting up plugins & extras..."

if command -v droid &>/dev/null; then
  droid plugin marketplace add https://github.com/parallel-web/parallel-agent-skills 2>/dev/null || true
  droid plugin install parallel@parallel-agent-skills 2>/dev/null || true
  green "    ✓ droid parallel plugin"
fi

if command -v bunx &>/dev/null; then
  bunx @0xsero/open-queue 2>/dev/null || true
elif command -v npx &>/dev/null; then
  npx @0xsero/open-queue 2>/dev/null || true
fi
green "    ✓ open-queue plugin"

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

# ─── 7. System env vars ─────────────────────────────────────────────────────

blue "==> Setting system environment..."

launchctl setenv CLI_PROXY_API_KEY "${CLI_PROXY_API_KEY}" 2>/dev/null || true
launchctl setenv FIREWORKS_API_KEY "${FIREWORKS_API_KEY}" 2>/dev/null || true
launchctl setenv OPENCODE_MESSAGE_QUEUE_MODE hold 2>/dev/null || true
launchctl setenv OPENCODE_EXPERIMENTAL_PLAN_MODE true 2>/dev/null || true
export OPENCODE_MESSAGE_QUEUE_MODE=hold
export OPENCODE_EXPERIMENTAL_PLAN_MODE=true

# Write ~/.secrets.zsh so shell sessions have these vars
# Re-export from .env so values are always current
cat > ~/.secrets.zsh <<SECRETS
$(cat "$DOTFILES_DIR/.env")
export OPENCODE_MESSAGE_QUEUE_MODE="\${OPENCODE_MESSAGE_QUEUE_MODE:-hold}"
export OPENCODE_EXPERIMENTAL_PLAN_MODE="\${OPENCODE_EXPERIMENTAL_PLAN_MODE:-true}"
SECRETS
green "    ✓ system env vars + ~/.secrets.zsh"

# ─── 8. Summary ─────────────────────────────────────────────────────────────

echo ""
green "==> Done! Restart your terminal or run: source ~/.zshrc"
echo ""
yellow "  One-time setup per machine:"
yellow "    1. Install Tailscale and join your tailnet"
yellow "    2. INFISICAL_API_URL=https://infisical-production-a65a.up.railway.app infisical login"
yellow "    3. INFISICAL_API_URL=https://infisical-production-a65a.up.railway.app infisical init"
yellow "    4. Open VibeProxy settings and connect ChatGPT/Codex and Claude/Anthropic"
echo ""
yellow "  Usage:"
yellow "    bash sync.sh        # pulls dev env secrets (default)"
yellow "    bash sync.sh prod   # pulls prod env secrets"
