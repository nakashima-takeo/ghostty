# orbe/

[Orbe](https://github.com/nakashima-takeo/orbe) が SwiftPM の binaryTarget で取り込む `GhosttyKit.zip` を作る包装。この fork で上流と違うのは、このディレクトリと `.github/workflows/orbe-ghosttykit.yml` だけ。

## 中身

zip の根: `GhosttyKit.xcframework/`（ReleaseFast・arm64）、`share/{ghostty,terminfo}/`、`fonts/`（JetBrains Mono Nerd Font 4 本）、`NOTICE`、`licenses/`。

- `build.sh <ghostty のソース> <出力 zip> [追加の zig build 引数…]`: 焼いて zip にする唯一の手順。
- `verify/check.sh <zip> <SHA>`: 公開前の自己検証（構成・リンクと起動・版）。
- `NOTICE`・`licenses/`: zip の中身の帰属。Orbe の `NOTICE`・`licenses/` と対で追随する。

## 公開

tag を打って workflow を起動し、Orbe の Package.swift を書き換える手順は、Orbe の [docs/guides/build.md](https://github.com/nakashima-takeo/orbe/blob/main/docs/guides/build.md) の「pin を進める」が持つ。Release `ghosttykit-<SHA>` は一度出したら差し替えない。

## 上流の追従

```bash
git fetch upstream && git merge upstream/main && git push origin main
orbe/disable-upstream-workflows.sh
```

GitHub の「Sync fork」は使わない。
