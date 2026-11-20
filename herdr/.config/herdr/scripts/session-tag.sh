#!/usr/bin/env bash
# Sets the active workspace's "tag" metadata token from a picker popup
# (prefix+t). Reported via `herdr workspace report-metadata`, not a label
# rename, so the session name itself is untouched. The token's value is the
# state's nerd font glyph, rendered as-is and colored by the rules in
# config.toml's [ui.sidebar.spaces]. "none" clears the token.
#
#   session-tag.sh                                  run the picker
#   session-tag.sh set <state|none> [workspace-id]  set a state directly
#   session-tag.sh sweep                            tag merged branches "done"
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

# Prints state $1's glyph (empty for none); fails for an unknown state.
glyph_of() {
  local row name glyph
  for row in "${states[@]}"; do
    IFS='|' read -r name _ glyph _ _ <<<"$row"
    [ "$name" = "$1" ] && printf '%s' "$glyph" && return 0
  done
  return 1
}

# set_tag <workspace-id> <glyph>; an empty glyph clears the tag.
set_tag() {
  if [ -z "$2" ]; then
    herdr workspace report-metadata "$1" --source herdr-session-color --clear-token tag
  else
    herdr workspace report-metadata "$1" --source herdr-session-color --token "tag=$2"
  fi
}

# Tags "done" every workspace whose branch's upstream was deleted on the remote
# (`[gone]` after a pruning fetch): the PR was merged or the branch dropped.
# Never-pushed branches have no upstream, so they're left alone. Run every few
# minutes by the tab_bar_right command entry in config.toml; prints nothing so
# that entry stays invisible.
sweep() {
  local done_glyph ws path repo branch fetched=' '
  done_glyph=$(glyph_of done)
  # A sweep runs unattended: fail instead of prompting for credentials.
  export GIT_TERMINAL_PROMPT=0 GIT_SSH_COMMAND='ssh -o BatchMode=yes'
  herdr workspace list |
    jq -r '.result.workspaces[] | select(.worktree) | [.workspace_id, .worktree.checkout_path, .worktree.repo_key] | @tsv' |
    while IFS=$'\t' read -r ws path repo; do
      # Worktrees of one repo share its refs, so fetch each repo once.
      case "$fetched" in *" $repo "*) ;; *)
        git -C "$path" fetch --quiet --prune 2>/dev/null || true
        fetched+="$repo "
      esac
      branch=$(git -C "$path" symbolic-ref --short -q HEAD) || continue
      [ "$(git -C "$path" for-each-ref --format='%(upstream:track)' "refs/heads/$branch")" = '[gone]' ] || continue
      [ "$(herdr workspace get "$ws" | jq -r '.result.workspace.tokens.tag // ""')" = "$done_glyph" ] && continue
      set_tag "$ws" "$done_glyph" >/dev/null || true
    done
}

case "${1:-}" in
  sweep) sweep; exit 0 ;;
  set)
    if glyph=$(glyph_of "${2:-}"); then
      set_tag "${3:-$(active_ws)}" "$glyph"
      exit
    fi
    names=$(for row in "${states[@]}"; do printf '%s|' "${row%%|*}"; done)
    echo "usage: $0 set <${names%|}> [workspace-id]" >&2
    exit 2
    ;;
esac

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
