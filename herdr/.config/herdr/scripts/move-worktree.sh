#!/usr/bin/env bash
# Move the focused linked-worktree workspace up or down among the other
# worktrees of the same repo in the sidebar. The sidebar only lets you drag
# top-level spaces (see herdrdev/herdr discussion #5992); the socket API's
# workspace.move_block already reorders children and keeps them grouped.
#
#   move-worktree.sh up|down

set -u

dir=${1:-}
case $dir in up|down) ;; *) echo "usage: $0 up|down" >&2; exit 2 ;; esac

SOCK=${HERDR_SOCKET_PATH:-$HOME/.config/herdr/herdr.sock}
command -v jq >/dev/null 2>&1 || exit 0

call() { # method params-json
  jq -cn --arg m "$1" --argjson p "$2" '{id: "move-worktree", method: $m, params: $p}' |
    nc -U -w1 "$SOCK"
}

list=$(call workspace.list '{}') || exit 0

# Siblings in sidebar order (by number); prints "<id> <neighbour id>" where the
# pair is (upper, lower) of the two workspaces to swap, or nothing at an edge.
read -r upper lower < <(jq -r --arg dir "$dir" '
  .result.workspaces as $all
  | ($all[] | select(.focused)) as $me
  | select($me.worktree.is_linked_worktree == true)
  | [$all[] | select(.worktree.is_linked_worktree == true
                     and .worktree.repo_key == $me.worktree.repo_key)]
  | sort_by(.number) | map(.workspace_id) as $ids
  | ($ids | index($me.workspace_id)) as $i
  | if $dir == "up" then (if $i > 0 then "\($ids[$i-1]) \($ids[$i])" else empty end)
    else (if $i < ($ids | length) - 1 then "\($ids[$i]) \($ids[$i+1])" else empty end) end
' <<<"$list")

[ -n "${upper:-}" ] || exit 0

# Swap: put the lower one directly before the upper one.
call workspace.move_block "$(jq -cn --arg l "$lower" --arg u "$upper" \
  '{workspace_ids: [$l], before_workspace_id: $u}')" >/dev/null
