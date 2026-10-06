#!/usr/bin/env bash
# この fork では上流の workflow を走らせない。orbe-ghosttykit.yml 以外の有効な workflow を全て無効にする（冪等）。
# 上流を merge して push した直後に毎回実行する。
set -euo pipefail

REPO="${1:-nakashima-takeo/ghostty}"
gh workflow list --repo "$REPO" --all --limit 1000 --json id,path,state \
  --jq '.[] | select(.state == "active" and .path != ".github/workflows/orbe-ghosttykit.yml") | .id' |
  while read -r ID; do
    gh workflow disable "$ID" --repo "$REPO"
  done
gh workflow list --repo "$REPO" --all --limit 1000
