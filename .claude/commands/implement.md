# 設計書からコードを実装する

引数として機能名を受け取ります（例: `/implement user-auth`）。

## Step 1: 設計書の読み込み

以下を読んでください：
- `docs/features/[機能名]/spec.md`
- `docs/features/[機能名]/test-spec.md`
- `docs/inception/security-policy.md`
- `CLAUDE.md`

spec.md または test-spec.md に「未解決事項」がある場合は実装前に確認してください。

## Step 2: 実装計画の提示

コードを書く前に以下を提示して承認を得てください：
- 作成・変更するファイルの一覧
- 採用するAPI層（tRPC / GraphQL）
- 特記事項

**承認を得てから実装に進むこと。**

## Step 3: テストの実装（先に必ずテストを書くこと）

**⚠️ テストファイルを作成するまで、実装コードを1行も書かないこと。**

`test-spec.md` の全テストケースをテストコードに落としてください。
この時点では実装コードが存在しないため、テストは必ず失敗（RED）します。
テストファイルの作成が完了したら次のステップに進んでください。

## Step 4: 実装

テストが GREEN になるように実装してください。

### 4-1: 型定義・Schema

- tRPC の場合: `src/server/routers/[機能名].ts`
- GraphQL の場合: `src/graphql/[機能名].graphql`

### 4-2: バックエンド実装

ビジネスロジック・データアクセス層を実装してください。
`security-policy.md` のルールを必ず守ること。

### 4-3: フロントエンド実装

コンポーネント・APIクライアントを実装してください。
CLAUDE.md のフレームワーク（Next.js / Vite）に合わせること。

### 4-4: テストが GREEN になっていることを確認する

## Step 5: status.md の更新

`docs/features/[機能名]/status.md` を更新してください：

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

## Step 6: 完了報告

- 実装ファイル一覧
- テスト結果（件数・結果）
- spec.md との差異（あれば必ず明記）

## 重要なルール
- spec.md・test-spec.md に書いていないことは実装しない
- E2Eテストが先、実装が後（TDD）
- セキュリティルールは必ず守る
