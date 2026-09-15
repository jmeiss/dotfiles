#!/bin/bash
# The caveman plugin's status line, when that plugin is installed in the active Claude profile.
# Prints nothing otherwise. Picks the newest install, so plugin updates don't break the path.
dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
script="$(ls -t "${dir%/}"/plugins/cache/caveman/caveman/*/hooks/caveman-statusline.sh 2>/dev/null | head -1)"

if [[ -n "$script" ]]; then
  exec bash "$script"
fi
cat >/dev/null
