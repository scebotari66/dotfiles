#!/usr/bin/env bash
set -e

for d in */; do stow "$d"; done

echo "Setup succeeded! ✅";
