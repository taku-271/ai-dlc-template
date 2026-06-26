# プロジェクト初期化

このプロジェクトのハーネスを整備します。

## Step 1: 技術スタックの検出

以下のファイルを読んでスタックを特定してください：
- `package.json`（存在する場合）
- `tsconfig.json`（存在する場合）
- `src/` 配下のファイル構成（存在する場合）

検出項目：
- Frontend: Next.js / Vite / なし
- Backend: Hono / Express / なし
- API層: tRPC / GraphQL / REST / なし
- テスト: Vitest / Jest / Playwright / なし

不明な点は必ず質問してください。勝手に決めないこと。

## Step 2: CLAUDE.md の更新

検出したスタックを `CLAUDE.md` の以下のセクションに反映してください：
- 技術スタック
- このプロジェクトについて（package.json の description などから推測）
- コーディング規約（スタックに合わせて補完）
- ディレクトリ構成（既存の src/ 構造から推測）
- テスト規約（テストフレームワークを記載）

既存の内容は上書きせず、プレースホルダー部分のみ埋めること。

## Step 3: docs/inception/ の確認・生成

`docs/inception/` の各ファイルが存在しない場合のみ作成してください。
既存ファイルは絶対に上書きしない。

作成するファイル：
- `docs/inception/requirements.md`（`docs/_templates/` のテンプレートを参考に）
- `docs/inception/domain-model.md`
- `docs/inception/security-policy.md`

## Step 4: 完了レポート

以下を日本語で報告してください：
- 検出した技術スタック
- 更新・作成したファイル
- 次にやること（`/develop [機能名]` でスタートできます）
