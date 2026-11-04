#!/bin/bash
# Daily sweep trigger (cron). Types the sweep request into the running
# Amigabot session in the Decibel tmux server; if no session is running,
# falls back to a macOS notification so a sweep is never silently missed.
# Mirrors decibel-majordomo/scripts/monday-docket.sh.
#
# Usage: sweep.sh [--dry-run] [--friday]
# Cron (weekdays 07:41, Fridays add the weekly transmission):
#   41 7 * * 1-4 /path/to/amigabot/scripts/sweep.sh
#   41 7 * * 5   /path/to/amigabot/scripts/sweep.sh --friday
TMUX_BIN=${TMUX_BIN:-/usr/local/bin/tmux}
DRY=0; FRIDAY=0
for a in "$@"; do case "$a" in --dry-run) DRY=1 ;; --friday) FRIDAY=1 ;; esac; done
PROMPT="Run the sweep skill now, then report to HQ."
[ "$FRIDAY" = 1 ] && PROMPT="It's Friday: run the sweep skill including the weekly transmission, then report to HQ."
SESSION=$($TMUX_BIN -L decibel ls -F '#{session_name}' 2>/dev/null | grep '^dcb-amigabot-' | head -1)

if [ "$DRY" = 1 ]; then
  echo "session: ${SESSION:-none (would notify)}"
  echo "prompt:  $PROMPT"
  exit 0
fi

if [ -n "$SESSION" ]; then
  $TMUX_BIN -L decibel send-keys -t "$SESSION" -l "$PROMPT"
  sleep 1
  $TMUX_BIN -L decibel send-keys -t "$SESSION" Enter
  echo "$(date '+%F %T') sent sweep request to $SESSION"
else
  /usr/bin/osascript -e 'display notification "No Amigabot session is running. Open one in HQ and say sweep." with title "Amigabot"'
  echo "$(date '+%F %T') no Amigabot session; notified"
fi
