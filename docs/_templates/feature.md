# [機能名] 設計書

## 概要
<!-- この機能が何をするか、なぜ必要かを1〜3行で -->

## ユーザーストーリー
- ユーザーは〇〇できる
- ユーザーは〇〇できる

## API定義

### tRPC Router
<!-- tRPC を使用する場合 -->
- `[router].[method](input)` → output
  - input: `{ field: type }`
  - output: `{ field: type }`

### GraphQL Schema
<!-- GraphQL を使用する場合 -->
```graphql
type Xxx {
  id: ID!
}

type Query {
  xxx(id: ID!): Xxx
}

type Mutation {
  createXxx(input: CreateXxxInput!): Xxx
}
```

## データモデル

| フィールド | 型 | 説明 |
|---|---|---|
| id | string | PK |
| createdAt | Date | 作成日時 |

## 画面・コンポーネント
- `/path`: 説明

## 制約・ビジネスルール
-

## セキュリティ・パフォーマンス要件
<!-- 機能固有のもののみ。共通ルールは security-policy.md を参照 -->
-

## 未解決事項
<!-- レビュー時に議論したい点・実装前に確認が必要な点 -->
-
