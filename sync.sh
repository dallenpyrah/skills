#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
VIBEPROXY_APP="/Applications/VibeProxy.app"
INFISICAL_ENV="${1:-dev}"
FAST_MODE="${FAST:-0}"  # Set FAST=1 to skip updates
SCREENPIPE_TMUX_SESSION="screenpipe"
SCREENPIPE_PORT="${SCREENPIPE_PORT:-3030}"
SCREENPIPE_LAUNCH_AGENT_ID="com.dallen.screenpipe"
SCREENPIPE_LAUNCH_AGENT_PATH="$HOME/Library/LaunchAgents/${SCREENPIPE_LAUNCH_AGENT_ID}.plist"
SCREENPIPE_WATCHDOG_PATH="$DOTFILES_DIR/screenpipe/ensure-screenpipe.sh"
SCREENPIPE_MCP_BIN=""

export PATH="$HOME/.bun/bin:$HOME/.local/bin:$PATH"

# Colors
green() { printf "\033[32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
blue() { printf "\033[34m%s\033[0m\n" "$1"; }
red() { printf "\033[31m%s\033[0m\n" "$1"; }

# Fast mode helper
should_update() {
  [[ "$FAST_MODE" != "1" ]]
}

ensure_bun_global_package() {
  local package="$1"

  if command -v bun &>/dev/null; then
    bun install -g "$package"
  elif command -v npm &>/dev/null; then
    npm install -g "$package"
  else
    red "    ✗ cannot install $package: bun/npm unavailable"
    exit 1
  fi
}

ensure_screenpipe_launch_agent() {
  mkdir -p "$HOME/Library/LaunchAgents"

  cat > "$SCREENPIPE_LAUNCH_AGENT_PATH" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${SCREENPIPE_LAUNCH_AGENT_ID}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>${SCREENPIPE_WATCHDOG_PATH}</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>HOME</key>
    <string>${HOME}</string>
    <key>PATH</key>
    <string>${HOME}/.bun/bin:${HOME}/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    <key>SCREENPIPE_PORT</key>
    <string>${SCREENPIPE_PORT}</string>
    <key>SCREENPIPE_TMUX_SESSION</key>
    <string>${SCREENPIPE_TMUX_SESSION}</string>
  </dict>
  <key>KeepAlive</key>
  <true/>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>${HOME}/.screenpipe/logs/launch-agent.log</string>
  <key>StandardErrorPath</key>
  <string>${HOME}/.screenpipe/logs/launch-agent.err.log</string>
</dict>
</plist>
PLIST

  chmod 644 "$SCREENPIPE_LAUNCH_AGENT_PATH"
  mkdir -p "$HOME/.screenpipe/logs"

  launchctl bootout "gui/$(id -u)" "$SCREENPIPE_LAUNCH_AGENT_PATH" >/dev/null 2>&1 || true
  launchctl bootstrap "gui/$(id -u)" "$SCREENPIPE_LAUNCH_AGENT_PATH"
  launchctl kickstart -k "gui/$(id -u)/${SCREENPIPE_LAUNCH_AGENT_ID}"
}

blue "==> Checking prerequisites..."

# Homebrew - only install if missing (check is fast)
if ! command -v brew &>/dev/null; then
  if should_update; then
    yellow "    Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null || true)"
  else
    red "    ✗ homebrew required but missing (set FAST=0 to auto-install)"
    exit 1
  fi
fi
green "    ✓ homebrew"

# GitHub CLI - fast check
if ! command -v gh &>/dev/null; then
  if should_update; then
    yellow "    Installing GitHub CLI..."
    brew install gh
  else
    red "    ✗ gh required but missing"
    exit 1
  fi
fi
if ! gh auth status &>/dev/null 2>&1; then
  red "    ✗ gh not authenticated. Run: gh auth login"
  exit 1
fi
green "    ✓ gh (authenticated)"

# Bun/Node - fast check
if ! command -v bun &>/dev/null && ! command -v node &>/dev/null; then
  if should_update; then
    yellow "    Installing bun..."
    brew install oven-sh/bun/bun
  else
    red "    ✗ bun/node required but missing"
    exit 1
  fi
fi
green "    ✓ bun/node"

# tmux - required for persistent ScreenPipe session management
if ! command -v tmux &>/dev/null; then
  if should_update; then
    yellow "    Installing tmux..."
    brew install tmux
  else
    red "    ✗ tmux required but missing"
    exit 1
  fi
fi
green "    ✓ tmux"

blue "==> Pulling secrets from Infisical..."

# Infisical - install only if missing (skip upgrade in fast mode)
if ! command -v infisical &>/dev/null; then
  yellow "    Installing Infisical CLI..."
  brew install infisical
elif should_update; then
  brew upgrade infisical 2>/dev/null || true
fi
green "    ✓ infisical cli"

# Infisical init check (fast local check)
if [ ! -f "$DOTFILES_DIR/.infisical.json" ]; then
  red "    ✗ .infisical.json not found — run: infisical init"
  exit 1
fi

# Pull secrets (this is required, network call)
INFISICAL_API_URL="${INFISICAL_API_URL:-https://infisical-production-a65a.up.railway.app}" \
  infisical export --env="$INFISICAL_ENV" --format=dotenv-export > "$DOTFILES_DIR/.env"
green "    ✓ secrets pulled (env: $INFISICAL_ENV)"

# Source secrets
set -a
source "$DOTFILES_DIR/.env"
set +a

# ─── Install tools (skip updates in fast mode) ────────────────────────────────

blue "==> Checking tools..."

# Claude - install only if missing, skip update check in fast mode
if ! command -v claude &>/dev/null; then
  yellow "    Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
elif should_update; then
  claude update 2>/dev/null || true
fi
green "    ✓ claude code"

# Codex - fast check
if ! command -v codex &>/dev/null; then
  if should_update; then
    yellow "    Installing Codex..."
    brew install --cask codex
  else
    yellow "    ⚠ codex not installed (skipped in fast mode)"
  fi
else
  green "    ✓ codex"
fi

# Droid - fast check
if ! command -v droid &>/dev/null; then
  if should_update; then
    yellow "    Installing Droid..."
    curl -fsSL https://factory.ai/install.sh | bash
  else
    yellow "    ⚠ droid not installed (skipped in fast mode)"
  fi
else
  green "    ✓ droid"
fi

# OpenCode - fast check
if ! command -v opencode &>/dev/null; then
  if should_update; then
    yellow "    Installing OpenCode..."
    brew install sst/tap/opencode
  else
    yellow "    ⚠ opencode not installed (skipped in fast mode)"
  fi
else
  green "    ✓ opencode"
fi

# VibeProxy - check if exists, skip download in fast mode
if [ ! -d "$VIBEPROXY_APP" ]; then
  if should_update; then
    yellow "    Downloading VibeProxy..."
    VIBEPROXY_URL="$(curl -fsSL "https://api.github.com/repos/automazeio/vibeproxy/releases/latest" 2>/dev/null \
      | grep -m1 '"browser_download_url":.*\.dmg"' \
      | sed -E 's/.*"browser_download_url": *"([^"]+)".*/\1/')"
    if [ -n "$VIBEPROXY_URL" ]; then
      TMPFILE="$(mktemp /tmp/vibeproxy-XXXXXX.dmg)"
      curl -fSL -o "$TMPFILE" "$VIBEPROXY_URL" 2>/dev/null || true
      if [ -f "$TMPFILE" ]; then
        hdiutil attach "$TMPFILE" -quiet -nobrowse 2>/dev/null || true
        cp -R "/Volumes/VibeProxy/VibeProxy.app" /Applications/ 2>/dev/null || true
        hdiutil detach "/Volumes/VibeProxy" -quiet 2>/dev/null || true
        rm -f "$TMPFILE"
      fi
    fi
  fi
fi
if [ -d "$VIBEPROXY_APP" ]; then
  green "    ✓ vibeproxy"
else
  yellow "    ⚠ vibeproxy not installed"
fi

# Shelf - fast check
if ! command -v shelf &>/dev/null; then
  yellow "    Installing shelf..."
  bun install -g @rikalabs/shelf 2>/dev/null || npm install -g @rikalabs/shelf 2>/dev/null || true
fi
green "    ✓ shelf"

# ScreenPipe CLI + MCP runtime
if ! command -v screenpipe &>/dev/null; then
  yellow "    Installing ScreenPipe CLI..."
  ensure_bun_global_package screenpipe
else
  green "    ✓ screenpipe cli"
fi

if ! command -v screenpipe-mcp &>/dev/null; then
  yellow "    Installing ScreenPipe MCP..."
  ensure_bun_global_package screenpipe-mcp
else
  green "    ✓ screenpipe mcp"
fi

SCREENPIPE_MCP_BIN="$(command -v screenpipe-mcp || true)"
if [[ -z "$SCREENPIPE_MCP_BIN" && -x "$HOME/.bun/bin/screenpipe-mcp" ]]; then
  SCREENPIPE_MCP_BIN="$HOME/.bun/bin/screenpipe-mcp"
fi
if [[ -z "$SCREENPIPE_MCP_BIN" ]]; then
  red "    ✗ screenpipe-mcp binary not found after install"
  exit 1
fi

# Parallel CLI - fast check
if ! command -v parallel-cli &>/dev/null; then
  yellow "    Installing parallel-cli..."
  curl -fsSL https://parallel.ai/install.sh | bash 2>/dev/null || true
fi
green "    ✓ parallel-cli"

# ─── Sync dotfiles (always run) ─────────────────────────────────────────────

blue "==> Syncing dotfiles..."

# Shell config - fast
if ! grep -qF "devbox/shell/shared.zsh" ~/.zshrc 2>/dev/null; then
  echo "" >> ~/.zshrc
  echo "source \"$DOTFILES_DIR/shell/shared.zsh\"" >> ~/.zshrc
fi
green "    ✓ shell config"

# Configs - parallel copy where possible
(
  cp "$DOTFILES_DIR/git/gitconfig" ~/.gitconfig
) &
GIT_PID=$!

(
  # Claude
  mkdir -p ~/.claude
  cp "$DOTFILES_DIR/claude/settings.json" ~/.claude/
  cp "$DOTFILES_DIR/claude/settings-kimi.json" ~/.claude/ 2>/dev/null || true
  cp "$DOTFILES_DIR/claude/settings-codex.json" ~/.claude/ 2>/dev/null || true
  cp "$DOTFILES_DIR/claude/settings-glm.json" ~/.claude/ 2>/dev/null || true
  cp "$DOTFILES_DIR/AGENTS.md" ~/.claude/CLAUDE.md
) &
CLAUDE_PID=$!

(
  # Codex
  mkdir -p ~/.codex
  cp "$DOTFILES_DIR/codex/config.toml" ~/.codex/
  cp "$DOTFILES_DIR/AGENTS.md" ~/.codex/
) &
CODEX_PID=$!

(
  # Droid
  mkdir -p ~/.factory ~/.factory/droids ~/.factory/skills
  cp "$DOTFILES_DIR/droid/settings.json" ~/.factory/
  cp "$DOTFILES_DIR/droid/mcp.json" ~/.factory/
  cp "$DOTFILES_DIR/AGENTS.md" ~/.factory/
  cp "$DOTFILES_DIR"/droid/droids/*.md ~/.factory/droids/ 2>/dev/null || true
  cp -r "$DOTFILES_DIR"/droid/skills/* ~/.factory/skills/ 2>/dev/null || true
  rm -f ~/.factory/config.json ~/.factory/settings.local.json
) &
DROID_PID=$!

(
  # OpenCode
  mkdir -p ~/.config/opencode/agents ~/.config/opencode/skills
  # Clean old agents first
  rm -f ~/.config/opencode/agents/smart.md ~/.config/opencode/agents/deep.md ~/.config/opencode/agents/librarian.md
  rm -f ~/.config/opencode/agents/oracle.md ~/.config/opencode/agents/painter.md ~/.config/opencode/agents/reviewer.md
  rm -f ~/.config/opencode/agents/rush.md
  # Copy current configs
  cp "$DOTFILES_DIR/opencode.json" ~/.config/opencode/
  cp "$DOTFILES_DIR/AGENTS.md" ~/.config/opencode/
  cp "$DOTFILES_DIR/tui.json" ~/.config/opencode/ 2>/dev/null || true
  cp "$DOTFILES_DIR"/opencode/agents/*.md ~/.config/opencode/agents/ 2>/dev/null || true
  cp -r "$DOTFILES_DIR"/opencode/skills/* ~/.config/opencode/skills/ 2>/dev/null || true
) &
OPENCODE_PID=$!

(
  # Ghostty
  mkdir -p ~/.config/ghostty
  cp "$DOTFILES_DIR/ghostty/config" ~/.config/ghostty/
) &
GHOSTTY_PID=$!

# Wait for all background jobs
wait $GIT_PID $CLAUDE_PID $CODEX_PID $DROID_PID $OPENCODE_PID $GHOSTTY_PID

green "    ✓ all configs synced"

# ─── MCP integrations (fast, only add if not present) ───────────────────────

blue "==> Setting up MCP..."

# Only add MCPs if commands exist (quick check)
if command -v claude &>/dev/null; then
  claude mcp add --transport http exa https://mcp.exa.ai/mcp --scope user 2>/dev/null || true
  claude mcp add --transport http paper http://127.0.0.1:29979/mcp --scope user 2>/dev/null || true
  claude mcp remove screenpipe --scope user 2>/dev/null || true
  claude mcp add screenpipe --scope user -- "$SCREENPIPE_MCP_BIN" 2>/dev/null || true
  green "    ✓ claude mcp"
fi

if command -v codex &>/dev/null; then
  while read -r mcp_name; do
    if [[ -n "$mcp_name" && "$mcp_name" != "screenpipe" ]]; then
      codex mcp remove "$mcp_name" 2>/dev/null || true
    fi
  done < <(codex mcp list 2>/dev/null | awk 'NR > 1 {print $1}')
  codex mcp remove screenpipe 2>/dev/null || true
  codex mcp add screenpipe -- "$SCREENPIPE_MCP_BIN" 2>/dev/null || true
  green "    ✓ codex mcp"
fi

if command -v droid &>/dev/null; then
  droid mcp add exa https://mcp.exa.ai/mcp --type http 2>/dev/null || true
  droid mcp add paper http://127.0.0.1:29979/mcp --type http 2>/dev/null || true
  green "    ✓ droid mcp"
fi

# ─── Plugins & extras (skip in fast mode) ────────────────────────────────────

blue "==> Setting up extras..."

if should_update; then
  # Droid plugin
  if command -v droid &>/dev/null; then
    droid plugin marketplace add https://github.com/parallel-web/parallel-agent-skills 2>/dev/null || true
    droid plugin install parallel@parallel-agent-skills 2>/dev/null || true
    green "    ✓ droid plugin"
  fi

  # OpenCode plugin (quick check)
  if command -v bunx &>/dev/null; then
    bunx @0xsero/open-queue 2>/dev/null || true
  elif command -v npx &>/dev/null; then
    npx @0xsero/open-queue 2>/dev/null || true
  fi
  green "    ✓ opencode plugin"

  # VibeProxy launch
  if [ -d "$VIBEPROXY_APP" ]; then
    open -gj "$VIBEPROXY_APP" 2>/dev/null || true
    green "    ✓ vibeproxy launched"
  fi
else
  yellow "    ⚠ plugins skipped (fast mode)"
fi

# ─── Environment vars (always run) ─────────────────────────────────────────

blue "==> Setting environment..."

# System env vars
launchctl setenv CLI_PROXY_API_KEY "${CLI_PROXY_API_KEY}" 2>/dev/null || true
launchctl setenv FIREWORKS_API_KEY "${FIREWORKS_API_KEY}" 2>/dev/null || true
launchctl setenv OPENCODE_MESSAGE_QUEUE_MODE hold 2>/dev/null || true
launchctl setenv OPENCODE_EXPERIMENTAL_PLAN_MODE true 2>/dev/null || true

export OPENCODE_MESSAGE_QUEUE_MODE=hold
export OPENCODE_EXPERIMENTAL_PLAN_MODE=true
launchctl setenv SCREENPIPE_PORT "${SCREENPIPE_PORT}" 2>/dev/null || true

# Write secrets file
cat > ~/.secrets.zsh <<SECRETS
$(cat "$DOTFILES_DIR/.env")
export OPENCODE_MESSAGE_QUEUE_MODE="\${OPENCODE_MESSAGE_QUEUE_MODE:-hold}"
export OPENCODE_EXPERIMENTAL_PLAN_MODE="\${OPENCODE_EXPERIMENTAL_PLAN_MODE:-true}"
SECRETS

green "    ✓ environment set"

# ─── ScreenPipe autostart (always run) ──────────────────────────────────────

blue "==> Setting up ScreenPipe..."

chmod +x "$SCREENPIPE_WATCHDOG_PATH"
ensure_screenpipe_launch_agent

green "    ✓ screenpipe launch agent"

# ─── Summary ───────────────────────────────────────────────────────────────

echo ""
green "==> Done!"

if [[ "$FAST_MODE" == "1" ]]; then
  echo ""
  yellow "  Fast mode: skipped updates"
  yellow "  Run 'FAST=0 bash sync.sh' for full update"
fi

echo ""
yellow "  Next steps:"
yellow "    source ~/.zshrc  # reload shell"
