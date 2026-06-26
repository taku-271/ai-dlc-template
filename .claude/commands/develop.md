# 機能開発フロー（全ステップ通し）

引数として機能名を受け取ります（例: `/develop user-auth`）。

spec.md の生成 → レビュー待ち → test-spec.md の生成 → レビュー待ち → 実装 の順で進みます。

---

## Step 1: spec.md の生成

`docs/_templates/feature.md` をベースに `docs/features/[機能名]/spec.md` を生成してください。

生成前に以下を読むこと：
- `docs/inception/requirements.md`
- `docs/inception/domain-model.md`
- `docs/inception/security-policy.md`
- `CLAUDE.md`（技術スタックの確認）
- `docs/features/` 配下の既存機能（命名規則・粒度の参考）

不明な点は生成前にまとめて質問してください。

生成完了後、以下のメッセージを出力して必ず停止してください：

「✅ spec.md を生成しました。`docs/features/[機能名]/spec.md` をレビューしてください。修正があれば直接ファイルを編集してください。問題なければ「OK」とお伝えください。」

**「OK」という返答があるまで次のステップに進まないこと。**

---

## Step 2: test-spec.md の生成（OK をもらってから実行）

`docs/_templates/test-spec.md` をベースに `docs/features/[機能名]/test-spec.md` を生成してください。

生成前に最新の `docs/features/[機能名]/spec.md` を読むこと。

含めるテストケース：
- ハッピーパス（正常系）
- 異常系・エラーケース
- 権限・認証に関するセキュリティケース（`docs/inception/security-policy.md` を参照）
- spec.md に記載されたパフォーマンス要件の検証

生成完了後、以下のメッセージを出力して必ず停止してください：

「✅ test-spec.md を生成しました。`docs/features/[機能名]/test-spec.md` をレビューしてください。修正があれば直接ファイルを編集してください。問題なければ「OK」とお伝えください。」

**「OK」という返答があるまで次のステップに進まないこと。**

---

## Step 3: 実装（OK をもらってから実行）

### 3-1: 実装計画の提示

コードを書く前に以下を提示して承認を得てください：
- 作成・変更するファイルの一覧
- 採用するAPI層（tRPC / GraphQL）
- 特記事項

**承認後に実装に進むこと。**

### 3-2: 実装順序

1. **E2Eテストの実装**（`test-spec.md` から）
2. **型定義・Schema**
3. **バックエンド実装**
4. **フロントエンド実装**

E2Eテストが通ることを確認しながら進めること。

### 3-3: status.md の更新

`docs/features/[機能名]/status.md` を作成・更新してください：

```markdown
# [機能名] 実装状況

## ステータス: 実装完了

## 実装済みファイル
- `src/...`

## テスト結果
- [ ] E2Eテスト: X件 passed
- [ ] 型チェック: passed

## spec.md との差異
なし / あり（内容を記載）
```

### 3-4: 完了報告

- 実装ファイル一覧
- テスト結果（件数・結果）
- spec.md との差異（あれば必ず明記）
