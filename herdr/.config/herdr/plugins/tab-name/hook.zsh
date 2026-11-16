# Live tab naming for the herdr "tab-name" plugin. herdr has no event for a
# pane's foreground process changing, so the shell reports it: just after a
# command starts (the short sleep lets it become the foreground process), again
# a moment later (a `pnpm dev` takes that long to start vite), and back at the
# prompt. Runs in the background so the prompt never waits. Each run reads the
# pane as it is now, so a late check after the command ended still says "zsh".
if [[ -n ${HERDR_PANE_ID:-} && -r ${XDG_CONFIG_HOME:-$HOME/.config}/herdr/plugins/tab-name/name.sh ]]; then
  _herdr_tab_name="${XDG_CONFIG_HOME:-$HOME/.config}/herdr/plugins/tab-name/name.sh"
  _herdr_tab_name_preexec() {
    ( sleep 0.2; bash "$_herdr_tab_name" --pane "$HERDR_PANE_ID"
      sleep 2;   bash "$_herdr_tab_name" --pane "$HERDR_PANE_ID" ) >/dev/null 2>&1 &!
  }
  _herdr_tab_name_precmd()  { bash "$_herdr_tab_name" --pane "$HERDR_PANE_ID" >/dev/null 2>&1 &! }
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _herdr_tab_name_preexec
  add-zsh-hook precmd  _herdr_tab_name_precmd
fi
