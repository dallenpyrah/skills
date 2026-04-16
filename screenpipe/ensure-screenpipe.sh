#!/bin/bash
set -euo pipefail

SESSION_NAME="${SCREENPIPE_TMUX_SESSION:-screenpipe}"
SCREENPIPE_BIN="${SCREENPIPE_BIN:-$HOME/.bun/bin/screenpipe}"
LOG_DIR="${SCREENPIPE_LOG_DIR:-$HOME/.screenpipe/logs}"
LOG_FILE="$LOG_DIR/watchdog.log"
PORT="${SCREENPIPE_PORT:-3030}"

mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$1" >> "$LOG_FILE"
}

if ! command -v tmux >/dev/null 2>&1; then
  log "tmux is not installed; watchdog exiting"
  exit 1
fi

if [ ! -x "$SCREENPIPE_BIN" ]; then
  log "screenpipe binary missing at $SCREENPIPE_BIN; watchdog exiting"
  exit 1
fi

start_session() {
  log "starting tmux session '$SESSION_NAME' on port $PORT"
  tmux new-session -d -s "$SESSION_NAME" \
    "export PATH=\"$HOME/.bun/bin:$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:\$PATH\"; exec \"$SCREENPIPE_BIN\" record --port \"$PORT\""
}

while true; do
  if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    start_session
  fi

  sleep 15
done
