#!/usr/bin/env bash
# Rename herdr tabs after the foreground process of their pane.
#
#   name.sh                 every tab (herdr events)
#   name.sh --pane <id>     only the tab holding that pane (zsh hook)
#   name.sh --reset         the focused tab, even if it was renamed by hand
#
# A multi-pane tab is named after its focused pane, or its first one when focus
# is elsewhere. Tabs renamed by hand are left alone: a label counts as ours only
# while it is herdr's numeric default or a name this script once gave that tab
# (kept in $STATE/<tab id>).

set -u

HERDR=${HERDR_BIN_PATH:-herdr}
STATE=${XDG_STATE_HOME:-$HOME/.local/state}/herdr-tab-name

command -v jq >/dev/null 2>&1 || exit 0
mkdir -p "$STATE" 2>/dev/null || exit 0

# The program in the pane's foreground. Starts from the process-group leader,
# named by how it was invoked (argv0, login shell "-" and path removed), then:
#   * an interpreter is named after its script: `node .../bin/pnpm` -> pnpm,
#     `python manage.py` -> manage
#   * a package manager is named after the program it started, found among the
#     other foreground processes: `pnpm dev` -> vite. Until that child exists
#     (or when it runs in-process) it reads "pnpm dev".
# Control characters are dropped, since the name ends up in the tab bar.
program_of() {
  "$HERDR" pane process-info --pane "$1" 2>/dev/null | jq -r '
    def base: tostring | ltrimstr("-") | split("/") | last;
    def interp: IN("node", "deno", "python", "python3", "ruby", "perl");
    def wrapper: IN("npm", "npx", "pnpm", "pnpx", "pnpm-native", "yarn",
      "bun", "bunx", "corepack", "sh", "bash", "zsh", "dash", "env");
    def wrapped: ((.argv0 // .argv[0] // .name // "") | base | interp)
      and ((.argv[1] // "-") | startswith("-") | not);
    def resolve:
      if wrapped then .argv[1] | base | sub("\\.([cm]?[jt]s|py|rb|pl)$"; "")
      else (.argv0 // .argv[0] // .name // "") | base end;
    def subcommand:
      (if wrapped then .argv[2:] else .argv[1:] end) // []
      | first(.[] | select(startswith("-") or IN("run", "exec", "x", "dlx") | not))
      // empty;

    .result.process_info as $pi
    | ($pi.foreground_processes // []) as $fp
    | (first($fp[] | select(.pid == $pi.foreground_process_group_id))
       // (if ($fp | length) == 1 then $fp[0] else empty end)) as $lead
    | ($lead | resolve) as $name
    | if ($name | wrapper) and ($name | IN("sh", "bash", "zsh", "dash") | not) then
        ([ $fp[] | select(.pid != $lead.pid) | { pid, n: resolve }
           | select(.n | wrapper | not) ] | min_by(.pid) | .n)
        // ([$name, ($lead | subcommand)] | join(" "))
      else $name end
    | gsub("[[:cntrl:]]"; "")
  ' 2>/dev/null
}

# Is <label> ours to replace on <tab>?
owned() {
  case $2 in
  "" | *[!0-9]*) ;;
  *) return 0 ;;                                 # herdr's default: a bare number
  esac
  [ -f "$STATE/$1" ] && grep -qxF -- "$2" "$STATE/$1"
}

mode=all
target=""
case "${1:-}" in
--pane) mode=pane; target=${2:-} ;;
--reset) mode=reset ;;
esac

panes=$("$HERDR" pane list 2>/dev/null) || exit 0
tabs=$("$HERDR" tab list 2>/dev/null) || exit 0

case $mode in
pane)
  target=$(printf '%s' "$panes" | jq -r --arg p "$target" \
    'first(.result.panes[] | select(.pane_id == $p) | .tab_id) // empty')
  [ -n "$target" ] || exit 0
  ;;
reset)
  target=$(printf '%s' "$tabs" | jq -r \
    'first(.result.tabs[] | select(.focused) | .tab_id) // empty')
  [ -n "$target" ] || exit 0
  ;;
esac

# One line per tab: tab id, the pane to name it after, the current label.
rows=$(jq -rn --argjson panes "$panes" --argjson tabs "$tabs" --arg only "$target" '
  ($tabs.result.tabs | map({ (.tab_id): .label }) | add // {}) as $labels
  | $panes.result.panes
  | map(select($only == "" or .tab_id == $only))
  | group_by(.tab_id)[]
  | (first(.[] | select(.focused)) // .[0]) as $p
  | [$p.tab_id, $p.pane_id, ($labels[$p.tab_id] // "" | gsub("[[:cntrl:]]"; " "))]
  | join("\u001f")
' 2>/dev/null) || exit 0

while IFS=$'\037' read -r tab pane label; do
  [ -n "$tab" ] || continue
  [ "$mode" = reset ] || owned "$tab" "$label" || continue
  want=$(program_of "$pane")
  [ -n "$want" ] && [ "$want" != "$label" ] || continue
  # Record the name before renaming, so a concurrent run never sees our own
  # label as a hand rename. The file only ever gains distinct names.
  state=$STATE/$tab
  grep -qxF -- "$want" "$state" 2>/dev/null || printf '%s\n' "$want" >>"$state"
  "$HERDR" tab rename "$tab" "$want" >/dev/null 2>&1
done <<<"$rows"
