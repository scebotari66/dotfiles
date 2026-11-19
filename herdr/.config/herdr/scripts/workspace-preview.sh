#!/usr/bin/env bash
# Workspace picker with a live preview of each workspace's focused pane.
# herdr's built-in picker (workspace_picker) has no preview and emits no
# events while navigating, so this replaces it with fzf in a herdr popup:
# j/k move, the right side shows what the highlighted workspace's focused
# pane currently displays, enter switches, esc/q cancels. / opens a search
# box (j/k/q then type); esc closes it and keeps the filtered list.
#
#   workspace-preview.sh                 run the picker
#   workspace-preview.sh --list          (internal) fzf input lines
#   workspace-preview.sh --preview <ws>  (internal) render one workspace

set -u
self=$0
# Popup commands may not get the login shell PATH; fzf and herdr are Homebrew.
PATH=/opt/homebrew/bin:$PATH

# jq filter: workspaces in sidebar order, i.e. by number, with each linked
# worktree moved right after its repo's main workspace (unless that repo has
# no main workspace open, then it stays at its own position).
ordered_jq() {
  cat <<'JQ'
.result.workspaces | sort_by(.number) as $all
| ([$all[] | select(.worktree.is_linked_worktree != true) | .worktree.repo_key // empty]) as $roots
| [ $all[]
    | select(.worktree.is_linked_worktree != true
             or (.worktree.repo_key as $k | $roots | index($k) | not))
    | . as $top
    | $top,
      ( if $top.worktree.is_linked_worktree != true and $top.worktree.repo_key then
          $all[] | select(.worktree.is_linked_worktree == true
                          and .worktree.repo_key == $top.worktree.repo_key)
        else empty end ) ]
JQ
}

case ${1:-} in
--list)
  # "<workspace_id>\t<label>" in sidebar order; linked worktrees indented
  # under their repo like the sidebar shows them.
  herdr workspace list | jq -r "$(ordered_jq)"'[]
    | "\(.workspace_id)\t\(if .worktree.is_linked_worktree then "  " else "" end)\(.label)"'
  exit
  ;;
--preview)
  pane=$(herdr api snapshot | jq -r --arg ws "${2:-}" '
    .result.snapshot as $s
    | ($s.workspaces[] | select(.workspace_id == $ws) | .active_tab_id) as $tab
    | $s.layouts[] | select(.tab_id == $tab) | .focused_pane_id')
  [ -n "$pane" ] && herdr pane read "$pane" --source visible --ansi
  exit
  ;;
esac

# Start the cursor on the currently focused workspace (fzf pos() is 1-based).
start=$(herdr workspace list | jq -r "$(ordered_jq)"' | map(.focused) | index(true) + 1')

ws=$("$self" --list | fzf \
  --no-input --layout reverse \
  --delimiter '\t' --with-nth 2 --accept-nth 1 \
  --bind "load:pos(${start:-1})" \
  --bind 'j:down,k:up,q:abort' \
  --bind '/:show-input+unbind(j,k,q,/)' \
  --bind 'esc:transform:[[ $FZF_INPUT_STATE = hidden ]] && echo abort || echo "hide-input+rebind(j,k,q,/)"' \
  --prompt '/ ' \
  --preview "'$self' --preview {1}" \
  --preview-window 'right,75%,follow,border-left' \
  --border none --info hidden --pointer '▌') || exit 0

[ -n "$ws" ] && herdr workspace focus "$ws" >/dev/null
