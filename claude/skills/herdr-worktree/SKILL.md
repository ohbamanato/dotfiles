---
name: herdr-worktree
description: 現在のリポジトリで git worktree を作成し herdr に新しい workspace(project)として開く、または herdr の worktree workspace を削除する。「新しい作業用 worktree を作って」「このタスク用に別ブランチで herdr project を立てて」「worktree + herdr でやりたい」「この worktree を消して」「終わった worktree を片付けて」といった指示で使う。
argument-hint: [ブランチ名 または タスクの説明(省略可)] [--base <ref>] | remove [ブランチ名 / workspace id]
---

# herdr-worktree

現在のリポジトリに git worktree を作り、herdr 上に新しい workspace として登録する。また、不要になった worktree workspace を削除する。
`herdr worktree create` が worktree 作成と workspace 作成を一度に行うので、`git worktree add` を別途実行しない。削除も同様に `git worktree remove` ではなく `herdr worktree remove` を使う。

指示が作成か削除かで、下の「作成手順」「削除手順」のどちらかに従う。

## 作成手順

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

## 削除手順

**削除は必ずユーザーの確認を取ってから実行する。確認なしに `herdr worktree remove` を実行してはならない。** ユーザーが最初の指示で「消して」と言っていても、対象を特定したあとに改めて確認する。

1. **前提確認**
   - `herdr status` で herdr サーバーが起動しているか確認する。停止中ならユーザーに伝える(勝手に起動しない)。

2. **対象を特定する**
   - `herdr worktree list --cwd "$(git rev-parse --show-toplevel)" --json` で worktree 一覧を取得する(カレントが git リポジトリでなければ、ユーザーにリポジトリのパスを聞くか `--workspace <id>` を使う)。
   - ブランチ名・workspace id・パスの指定があれば、それに一致するものを選ぶ。
   - 指定がない/曖昧な場合は、候補を `AskUserQuestion` で提示して選んでもらう(複数選択可)。
   - メインの worktree(リポジトリ本体)は削除対象にしない。

3. **状態を調べる**
   - 対象ごとに `git -C <worktree-path> status --short` と `git -C <worktree-path> log --oneline @{u}..HEAD 2>/dev/null`(upstream がなければ base ブランチとの差分)で、未コミット変更・未 push コミットの有無を調べる。

4. **ユーザーに確認する(必須)**
   - `AskUserQuestion` で、対象ごとに次を示して実行してよいか聞く:
     - workspace id / ブランチ名 / worktree パス
     - 未コミット変更・未 push コミットの有無(あれば件数と内容の要約)
   - 選択肢は「削除する」「やめる」を基本とする。未コミット変更があるときは `--force` が必要になるので、「--force で強制削除する(変更は失われる)」を別の選択肢として明示し、ユーザーが選んだときだけ `--force` を付ける。
   - 「やめる」が選ばれた、または明確な承認が得られない場合は何もせず終了する。

5. **削除**
   ```bash
   herdr worktree remove --workspace <id> [--force] --json
   ```
   - 確認で承認された対象だけを実行する。
   - ブランチ自体の削除(`git branch -d`)はこの skill では行わない。必要ならユーザーに提案だけする。

6. **結果を報告**
   - 削除した workspace id・ブランチ名・パスを簡潔に伝える。
   - 失敗した場合は herdr のエラー出力をそのまま示す。`--force` での再実行が必要そうでも、再度確認を取ってから行う。

## 補足コマンド

- 一覧: `herdr worktree list (--cwd <repo> | --workspace <id>) [--json]`
- 既存ブランチ/パスを開く: `herdr worktree open --cwd <repo> (--branch NAME | --path PATH)`

## 注意

- コミット・push はこの skill の範囲外。
- worktree 内のコードを変更する作業は、新しい workspace 側で行う想定。このセッションの cwd は変えない。
- このセッション自身の cwd が削除対象の worktree 内にある場合は、その旨を確認時に伝える。
