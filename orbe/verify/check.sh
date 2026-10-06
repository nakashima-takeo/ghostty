#!/usr/bin/env bash
# 公開する前の GhosttyKit.zip を確かめる。根の構成・NOTICE が指すライセンス全文・リンクと起動・焼いた版（ReleaseFast と ghostty の SHA）。
# 使い方: orbe/verify/check.sh <GhosttyKit.zip> <焼いた ghostty の 40 桁 SHA>
set -euo pipefail

[ $# -eq 2 ] || { echo "使い方: $0 <GhosttyKit.zip> <焼いた ghostty の 40 桁 SHA>" >&2; exit 2; }
HERE="$(cd "$(dirname "$0")" && pwd)"
ZIP="$1"
SHA="$2"
fail() { echo "エラー: $*" >&2; exit 1; }

ENTRIES="$(zipinfo -1 "$ZIP")"
has() { grep -qxF "$1" <<<"$ENTRIES"; }
for ENTRY in GhosttyKit.xcframework/Info.plist share/ghostty/shell-integration/ share/terminfo/78/xterm-ghostty \
  fonts/JetBrainsMonoNerdFont-{Regular,Bold,Italic,BoldItalic}.ttf NOTICE licenses/ghostty-LICENSE.txt; do
  has "$ENTRY" || fail "zip に $ENTRY が無い"
done
for LICENSE in $(unzip -p "$ZIP" NOTICE | grep -oE 'licenses/[A-Za-z0-9._-]+\.txt' | sort -u); do
  has "$LICENSE" || fail "NOTICE が指す $LICENSE が zip に無い"
done

SCRATCH="$(mktemp -d)"
trap 'rm -rf "$SCRATCH" "$HERE/GhosttyKit.zip"' EXIT
cp "$ZIP" "$HERE/GhosttyKit.zip"
swift build --package-path "$HERE" --scratch-path "$SCRATCH"
OUT="$("$SCRATCH/debug/verify")"
echo "$OUT"

grep -qxF "build_mode=ReleaseFast" <<<"$OUT" || fail "ReleaseFast で焼かれていない"
HASH="$(sed -n 's/^version=.*+\([0-9a-f]*\)$/\1/p' <<<"$OUT")"
[ "${#HASH}" -ge 7 ] && [[ "$SHA" == "$HASH"* ]] || fail "版の SHA ($HASH) が $SHA と合わない"
echo "==> OK"
