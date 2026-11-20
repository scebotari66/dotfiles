#!/usr/bin/env bash
# Sets the active workspace's "tag" metadata token from a picker popup
# (prefix+t). Reported via `herdr workspace report-metadata`, not a label
# rename, so the session name itself is untouched. The token's value is the
# state's nerd font glyph, rendered as-is and colored by the rules in
# config.toml's [ui.sidebar.spaces]. "none" clears the token.
#
#   session-tag.sh                                  run the picker
#   session-tag.sh set <state|none> [workspace-id]  set a state directly
set -euo pipefail
# Popup commands may not get the login shell PATH; fzf and herdr are Homebrew.
PATH=/opt/homebrew/bin:$PATH

# Byte escapes, not literal glyphs, so editors/tools can't silently drop the
# private-use nerd font codepoints. Plain \x escapes because macOS's bash 3.2
# has no $'\u...'.
FLASK=$'\xef\x83\x83'    # U+F0C3
FIRE=$'\xef\x81\xad'     # U+F06D
PR=$'\xef\x90\x87'       # U+F407 git-pull-request
EYE=$'\xef\x81\xae'      # U+F06E
COMMENTS=$'\xef\x82\x86' # U+F086
BAN=$'\xef\x81\x9e'      # U+F05E
PAUSE=$'\xef\x81\x8c'    # U+F04C
CHECK=$'\xef\x80\x8c'    # U+F00C

# Catppuccin Mocha. Color = who the ball is with.
blue='137;180;250'   # I'm actively on it
peach='250;179;135'  # needs me now
red='243;139;168'    # stuck
yellow='249;226;175' # waiting on someone else
mauve='203;166;247'  # someone else's work
green='166;227;161'  # done
grey='108;112;134'   # parked

# name|picker key|glyph|color|description. Picker order is table order.
# Glyphs and colors must match the rules in config.toml.
states=(
  "none|n|||no tag"
  "wip|w|$FLASK|$blue|work in progress"
  "urgent|u|$FIRE|$peach|drop everything else"
  "pr-open|o|$PR|$yellow|own PR open, awaiting review"
  "changes|c|$COMMENTS|$peach|review comments to address"
  "reviewing|r|$EYE|$mauve|reviewing someone else's PR"
  "blocked|b|$BAN|$red|waiting on a dependency/answer/CI"
  "hold|h|$PAUSE|$grey|parked for now"
  "done|d|$CHECK|$green|merged, session can be closed"
)

active_ws() {
  echo "${HERDR_ACTIVE_WORKSPACE_ID:-$(herdr workspace list | jq -r '.result.workspaces[] | select(.focused) | .workspace_id')}"
}

if [ "${1:-}" = set ]; then
  ws="${3:-$(active_ws)}"
  for row in "${states[@]}"; do
    IFS='|' read -r name _ glyph _ _ <<<"$row"
    [ "$name" = "${2:-}" ] || continue
    if [ -z "$glyph" ]; then
      exec herdr workspace report-metadata "$ws" --source herdr-session-color --clear-token tag
    fi
    exec herdr workspace report-metadata "$ws" --source herdr-session-color --token "tag=$glyph"
  done
  names=$(for row in "${states[@]}"; do printf '%s|' "${row%%|*}"; done)
  echo "usage: $0 set <${names%|}> [workspace-id]" >&2
  exit 2
fi

# Picker: every state with its colored glyph, cursor on the current one.
# j/k move, enter sets the state, esc/q cancels. Each state's key sets it
# straight away.
ws=$(active_ws)
tag=$(herdr workspace get "$ws" | jq -r '.result.workspace.tokens.tag // ""')
start=1 i=0 lines='' keybinds=''
for row in "${states[@]}"; do
  IFS='|' read -r name key glyph color desc <<<"$row"
  i=$((i + 1))
  [ -n "$tag" ] && [ "$glyph" = "$tag" ] && start=$i
  icon=' '
  [ -n "$glyph" ] && icon=$'\033[38;2;'"${color}m${glyph}"$'\033[0m'
  lines+=$(printf '%s\t%s  %s  %-10s %s' "$name" "$icon" "$key" "$name" "$desc")$'\n'
  keybinds+="$key:pos($i)+accept,"
done

state=$(printf '%s' "$lines" |
  fzf --ansi --no-input --layout reverse \
    --delimiter '\t' --with-nth 2 --accept-nth 1 \
    --bind "load:pos($start)" \
    --bind 'j:down,k:up,q:abort' \
    --bind "${keybinds%,}" \
    --border none --info hidden --pointer '▌') || exit 0

[ -n "$state" ] && exec "$0" set "$state" "$ws"
