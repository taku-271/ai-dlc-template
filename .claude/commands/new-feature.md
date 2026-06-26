# 設計書（spec.md）の生成

引数として機能名を受け取ります（例: `/new-feature user-auth`）。

## Step 1: コンテキストの読み込み

以下を読んでください：
- `docs/inception/requirements.md`
- `docs/inception/domain-model.md`
- `docs/inception/security-policy.md`
- `CLAUDE.md`（技術スタックの確認）
- `docs/features/` 配下の既存機能（命名規則・粒度の参考）

## Step 2: ヒアリング

以下をまとめて質問してください（一度に聞く）：
1. この機能の目的・背景は何ですか？
2. 主なユーザーアクションは何ですか？
3. 関連する既存機能はありますか？
4. 機能固有のセキュリティ・パフォーマンス要件はありますか？

## Step 3: spec.md の生成

`docs/_templates/feature.md` をベースに `docs/features/[機能名]/spec.md` を生成してください。

- API定義は CLAUDE.md で確認したAPI層に合わせる
- 機能固有のセキュリティ・パフォーマンス要件を必ず含める
- 不明点は「未解決事項」セクションに記載する
- `docs/features/[機能名]/status.md` を空ファイルで作成する

## Step 4: domain-model.md の更新確認

新しいエンティティ・用語が登場する場合、`docs/inception/domain-model.md` への追記案を提示してください（自動で書き込まず、承認を得ること）。

## Step 5: 完了報告

- 生成したファイルのパス
- レビューで特に確認してほしいポイント
- 未解決事項の一覧
- domain-model.md の更新が必要な場合はその内容

## 重要なルール
- 仕様を勝手に決めない。不明な点は必ずヒアリングする
- コードは一切生成しない（設計書のみ）
