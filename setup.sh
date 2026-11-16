#!/usr/bin/env bash
set -e

for d in */; do stow "$d"; done

# Register herdr plugins. Safe to re-run; re-run after editing a plugin's
# herdr-plugin.toml, since herdr keeps its own copy of the manifest.
if command -v herdr >/dev/null; then
  for p in ~/.config/herdr/plugins/*/herdr-plugin.toml; do
    [ -e "$p" ] && herdr plugin link "$(dirname "$p")" >/dev/null
  done
fi

echo "Setup succeeded! ✅";
