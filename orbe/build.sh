#!/usr/bin/env bash
# Orbe 向けの GhosttyKit.zip を作る。ghostty のソースを焼き、xcframework・share・フォント・ライセンス表記を 1 つの zip に詰める。
# 使い方: orbe/build.sh <ghostty のソース> <出力 zip> [追加の zig build 引数…]
# zig は PATH 上のものを使う（版はソースの build.zig.zon の minimum_zig_version に合わせる）。
set -euo pipefail

[ $# -ge 2 ] || { echo "使い方: $0 <ghostty のソース> <出力 zip> [追加の zig build 引数…]" >&2; exit 2; }
PACK="$(cd "$(dirname "$0")" && pwd)"
SRC="$(cd "$1" && pwd)"
mkdir -p "$(dirname "$2")"
OUT="$(cd "$(dirname "$2")" && pwd)/$(basename "$2")"
shift 2

# ghostty の build は HEAD に付いたタグを全てリリースの版（vX.Y.Z）とみなし、違えば panic する。
# この fork の Release タグ（ghosttykit-<SHA>）は焼いたコミットそのものに付くので、取ってきていれば先に止める。
if TAG="$(git -C "$SRC" describe --exact-match --tags 2>/dev/null)" && [[ ! "$TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "エラー: $SRC の HEAD にタグ $TAG が付いていて ghostty の build が止まる。--no-tags で取るか、手元のタグを消せ" >&2
  exit 1
fi

(cd "$SRC" && zig build -Demit-xcframework=true -Dxcframework-target=native -Doptimize=ReleaseFast -Demit-macos-app=false "$@")

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/share" "$STAGE/fonts"
cp -R "$SRC/macos/GhosttyKit.xcframework" "$STAGE/GhosttyKit.xcframework"
cp -R "$SRC/zig-out/share/ghostty" "$STAGE/share/ghostty"
cp -R "$SRC/zig-out/share/terminfo" "$STAGE/share/terminfo"
for STYLE in Regular Bold Italic BoldItalic; do
  cp "$SRC/src/font/res/JetBrainsMonoNerdFont-$STYLE.ttf" "$STAGE/fonts/"
done
cp "$PACK/NOTICE" "$STAGE/NOTICE"
cp -R "$PACK/licenses" "$STAGE/licenses"
cp "$SRC/LICENSE" "$STAGE/licenses/ghostty-LICENSE.txt"

rm -f "$OUT"
(cd "$STAGE" && zip -qrX "$OUT" .)
echo "==> $OUT"
