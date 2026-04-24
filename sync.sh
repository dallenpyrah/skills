#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VIBEPROXY_APP="/Applications/VibeProxy.app"

FAST=0
SECRETS=1
SYSTEMS=1
TOOLS=1
DOTFILES=1
MCP=1
EXTRAS=1

usage() {
  cat <<USAGE
Usage: $0 [options]

Options:
  --fast           Skip updates and secret pull
  --secrets        Pull secrets from Infisical
  --no-secrets     Skip pulling secrets from Infisical
  --systems        Install system prerequisites
  --no-systems     Skip system prerequisites
  --tools          Install dev tools
  --no-tools       Skip dev tools
  --dotfiles       Sync dotfiles
  --no-dotfiles    Skip dotfile sync
  --mcp            Configure MCP servers
  --no-mcp         Skip MCP setup
  --extras         Run extras
  --no-extras      Skip extras
USAGE
}

while (($#)); do
  case "$1" in
    --fast) FAST=1; SECRETS=0 ;;
    --secrets) SECRETS=1 ;;
    --skip-secrets|--no-secrets) SECRETS=0 ;;
    --systems) SYSTEMS=1 ;;
    --skip-systems|--no-systems) SYSTEMS=0 ;;
    --tools) TOOLS=1 ;;
    --skip-tools|--no-tools) TOOLS=0 ;;
    --dotfiles) DOTFILES=1 ;;
    --skip-dotfiles|--no-dotfiles) DOTFILES=0 ;;
    --mcp) MCP=1 ;;
    --skip-mcp|--no-mcp) MCP=0 ;;
    --extras) EXTRAS=1 ;;
    --skip-extras|--no-extras) EXTRAS=0 ;;
    -h|--help|help) usage; exit 0 ;;
    *) exit 2 ;;
  esac
  shift
done

if [[ "${SYNC_VERBOSE:-0}" != "1" ]]; then
  exec >/dev/null 2>&1
fi

INFISICAL_ENV="${INFISICAL_ENV:-dev}"

enabled() {
  [[ "$1" == "1" ]]
}

can_update() {
  [[ "$FAST" != "1" ]]
}

has() {
  command -v "$1" >/dev/null 2>&1
}

append_once() {
  local line="$1"
  local file="$2"

  touch "$file"
  grep -qF "$line" "$file" || printf '\n%s\n' "$line" >> "$file"
}

install_systems() {
  if ! has brew; then
    can_update || exit 1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null || true)"
  fi

  if ! has gh; then
    can_update || exit 1
    brew install gh
  fi

  gh auth status >/dev/null 2>&1 || exit 1

  if ! has bun && ! has node; then
    can_update || exit 1
    brew install oven-sh/bun/bun
  fi
}

load_secrets() {
  if ! has infisical; then
    brew install infisical
  elif can_update; then
    brew upgrade infisical || true
  fi

  [[ -f "$DOTFILES_DIR/.infisical.json" ]] || exit 1

  INFISICAL_API_URL="${INFISICAL_API_URL:-https://infisical-production-a65a.up.railway.app}" \
    infisical export --env="$INFISICAL_ENV" --format=dotenv-export > "$DOTFILES_DIR/.env"

  set -a
  source "$DOTFILES_DIR/.env"
  set +a
}

install_vibeproxy() {
  [[ ! -d "$VIBEPROXY_APP" ]] || return 0
  can_update || return 0

  local url tmp
  url="$(
    curl -fsSL "https://api.github.com/repos/automazeio/vibeproxy/releases/latest" |
      grep -m1 '"browser_download_url":.*\.dmg"' |
      sed -E 's/.*"browser_download_url": *"([^"]+)".*/\1/'
  )"
  [[ -n "$url" ]] || return 0

  tmp="$(mktemp /tmp/vibeproxy-XXXXXX.dmg)"
  curl -fSL -o "$tmp" "$url" || return 0
  hdiutil attach "$tmp" -quiet -nobrowse || return 0
  cp -R "/Volumes/VibeProxy/VibeProxy.app" /Applications/ || true
  hdiutil detach "/Volumes/VibeProxy" -quiet || true
  rm -f "$tmp"
}

install_tools() {
  if ! has claude; then
    curl -fsSL https://claude.ai/install.sh | bash
  elif can_update; then
    claude update || true
  fi

  if ! has codex && can_update; then
    brew install --cask codex
  fi

  install_vibeproxy

  if ! has shelf; then
    bun install -g @rikalabs/shelf || npm install -g @rikalabs/shelf || true
  fi

  if ! has parallel-cli; then
    curl -fsSL https://parallel.ai/install.sh | bash || true
  fi

  if ! has uvx; then
    curl -LsSf https://astral.sh/uv/install.sh | sh || true
  fi

  if ! has ast-grep; then
    brew install ast-grep || true
  fi
}

sync_claude() {
  mkdir -p "$HOME/.claude/skills" "$HOME/.claude/commands"
  cp "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/"
  cp "$DOTFILES_DIR"/claude/settings-*.json "$HOME/.claude/" 2>/dev/null || true
  cp "$DOTFILES_DIR/AGENTS.md" "$HOME/.claude/CLAUDE.md"
  cp -R "$DOTFILES_DIR"/skills/* "$HOME/.claude/skills/" 2>/dev/null || true
  cp "$DOTFILES_DIR"/claude/commands/*.md "$HOME/.claude/commands/" 2>/dev/null || true
  cp -R "$DOTFILES_DIR"/claude/commands/autoresearch "$HOME/.claude/commands/" 2>/dev/null || true
}

sync_codex() {
  mkdir -p "$HOME/.codex/skills"
  cp "$DOTFILES_DIR/codex/config.toml" "$HOME/.codex/"
  cp "$DOTFILES_DIR/AGENTS.md" "$HOME/.codex/"
  cp -R "$DOTFILES_DIR"/skills/* "$HOME/.codex/skills/" 2>/dev/null || true
}

sync_dotfiles() {
  append_once "source \"$DOTFILES_DIR/shell/shared.zsh\"" "$HOME/.zshrc"

  cp "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
  sync_claude
  sync_codex

  mkdir -p "$HOME/.config/ghostty"
  cp "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/"
}

setup_mcp() {
  if has claude; then
    claude mcp add --transport http exa https://mcp.exa.ai/mcp --scope user || true
    claude mcp add --transport http paper http://127.0.0.1:29979/mcp --scope user || true
    claude mcp add --transport http gh_grep https://mcp.grep.app --scope user || true
    claude mcp add --transport http context7 https://mcp.context7.com/mcp --scope user || true
    claude mcp add --scope user ast-grep -- uvx --from git+https://github.com/ast-grep/ast-grep-mcp ast-grep-server || true
  fi

  if has codex; then
    codex mcp add exa --url https://mcp.exa.ai/mcp || true
    codex mcp add paper --url http://127.0.0.1:29979/mcp || true
    codex mcp add gh_grep --url https://mcp.grep.app || true
    codex mcp add context7 --url https://mcp.context7.com/mcp || true
  fi
}

run_extras() {
  can_update || return 0
  [[ -d "$VIBEPROXY_APP" ]] && open -gj "$VIBEPROXY_APP" || true
}

write_environment() {
  if enabled "$SECRETS"; then
    launchctl setenv CLI_PROXY_API_KEY "${CLI_PROXY_API_KEY:-}" || true
    launchctl setenv FIREWORKS_API_KEY "${FIREWORKS_API_KEY:-}" || true
    cp "$DOTFILES_DIR/.env" "$HOME/.secrets.zsh"
  else
    : > "$HOME/.secrets.zsh"
  fi
}

enabled "$SYSTEMS" && install_systems
enabled "$SECRETS" && load_secrets
enabled "$TOOLS" && install_tools
enabled "$DOTFILES" && sync_dotfiles
enabled "$MCP" && setup_mcp
enabled "$EXTRAS" && run_extras
write_environment
