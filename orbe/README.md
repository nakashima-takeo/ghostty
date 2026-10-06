# orbe/

[Orbe](https://github.com/nakashima-takeo/orbe) が SwiftPM の binaryTarget で取り込む `GhosttyKit.zip` を作る包装。この fork で上流と違うのは、このディレクトリと `.github/workflows/orbe-ghosttykit.yml` だけ。

## 中身

zip の根: `GhosttyKit.xcframework/`（ReleaseFast・arm64）、`share/{ghostty,terminfo}/`、`fonts/`（JetBrains Mono Nerd Font 4 本）、`NOTICE`、`licenses/`。

- `build.sh <ghostty のソース> <出力 zip> [追加の zig build 引数…]`: 焼いて zip にする唯一の手順。
- `verify/check.sh <zip> <SHA>`: 公開前の自己検証（構成・リンクと起動・版）。
- `NOTICE`・`licenses/`: zip の中身の帰属。Orbe の `NOTICE`・`licenses/` と対で追随する。

## 公開

焼くコミットは fork のいずれかのブランチから到達できること。tag を所有者のトークンで打ってから workflow を起動する（GITHUB_TOKEN は、workflow ファイルが既定ブランチと違うコミットに tag を作れない）。

```bash
gh api repos/nakashima-takeo/ghostty/git/refs -f ref=refs/tags/ghosttykit-<40 桁 SHA> -f sha=<40 桁 SHA>
gh workflow run orbe-ghosttykit.yml --repo nakashima-takeo/ghostty --ref main -f ghostty_sha=<40 桁 SHA>
```

workflow は zip を自己検証してから、その tag に Release `ghosttykit-<SHA>` を出す。Release は一度出したら差し替えない。workflow が Release を出す前に失敗したら、同じ tag のまま再び起動すればよい。

## 上流の追従

```bash
git fetch upstream && git merge upstream/main && git push origin main
orbe/disable-upstream-workflows.sh
```

GitHub の「Sync fork」は使わない。
