---
name: herdr-worktree
description: 現在のリポジトリで git worktree を作成し、herdr に新しい workspace(project)として開く。「新しい作業用 worktree を作って」「このタスク用に別ブランチで herdr project を立てて」「worktree + herdr でやりたい」といった指示で使う。
argument-hint: [ブランチ名 または タスクの説明(省略可)] [--base <ref>]
---

# herdr-worktree

現在のリポジトリに git worktree を作り、herdr 上に新しい workspace として登録する。
`herdr worktree create` が worktree 作成と workspace 作成を一度に行うので、`git worktree add` を別途実行しない。

## 手順

1. **前提確認**
   - `git rev-parse --show-toplevel` でカレントが git リポジトリか確認する。違う場合は中断してユーザーに伝える。
   - `herdr status` で herdr サーバーが起動しているか確認する。停止中ならユーザーに伝える(勝手に起動しない)。

2. **ブランチ名を決める**(名前に決まりはなく、任意でよい)
   - ブランチ名が明示されていればそのまま使う。
   - 指定がなければ、タスクの説明から短い kebab-case の名前を自分で作る。説明もなければ `wt-$(date +%m%d-%H%M)` のようにする。ユーザーに聞き返さない。
   - 既存ブランチと衝突する場合は、`herdr worktree open --branch <name>` を使うか、末尾に `-2` などを付けて別名にする。
   - 実際に使った名前は結果報告で伝える。

3. **作成**
   ```bash
   herdr worktree create --cwd "$(git rev-parse --show-toplevel)" \
     --branch <branch> [--base <ref>] --label <branch> --focus --json
   ```
   - `--base` は指示があるときだけ付ける(省略時は herdr の既定)。
   - `--path` は指示がない限り付けない(herdr の既定配置に従う)。
   - 他の作業を邪魔したくない指示があれば `--focus` の代わりに `--no-focus`。

4. **結果を報告**
   - `--json` の出力から workspace id、worktree のパス、ブランチ名を簡潔に伝える。
   - 失敗した場合は herdr のエラー出力をそのまま示す。

## 補足コマンド

- 一覧: `herdr worktree list --cwd <repo>`
- 既存ブランチ/パスを開く: `herdr worktree open --cwd <repo> (--branch NAME | --path PATH)`
- 削除: `herdr worktree remove --workspace <id>` — **破壊的なので、ユーザーが明示的に頼んだときだけ実行し、未コミット変更がある場合は `--force` を勝手に付けない。**

## 注意

- コミット・push はこの skill の範囲外。
- worktree 内のコードを変更する作業は、新しい workspace 側で行う想定。このセッションの cwd は変えない。
