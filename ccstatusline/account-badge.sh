#!/bin/bash
# Account badge for ccstatusline.
#   ~/.claude-<name>     -> <Name>
#   ~/.claude (default)  -> from the logged-in email: *@ergana.ai -> Ergana, anything else -> Perso
# The default folder can hold either account: devcontainers mount the Ergana profile as ~/.claude.
cat >/dev/null

dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
dir="${dir%/}"
base="$(basename "$dir")"

case "$base" in
  .claude-*)
    suffix="${base#.claude-}"
    name="$(printf '%s' "${suffix:0:1}" | tr '[:lower:]' '[:upper:]')${suffix:1}"
    ;;
  *)
    # Same state file Claude Code uses: inside CLAUDE_CONFIG_DIR when set, ~/.claude.json otherwise.
    state="$HOME/.claude.json"
    [[ -n "${CLAUDE_CONFIG_DIR:-}" ]] && state="$dir/.claude.json"
    email="$(jq -r '.oauthAccount.emailAddress // empty' "$state" 2>/dev/null)"
    case "$email" in
      *@ergana.ai) name="Ergana" ;;
      "") name="Not logged in" ;;
      *) name="Perso" ;;
    esac
    ;;
esac

printf '%s' "$name"
