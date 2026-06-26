# AI-DLC テンプレート

[AI-DLC（AI-Driven Development Lifecycle）](https://aws.amazon.com/jp/blogs/news/ai-driven-development-life-cycle/) をベースに、**人間が設計書だけをレビューし、Claude Code がコードを実装する**開発フローのテンプレートです。

## コンセプト

- 人間はコードを書かない・レビューしない
- 人間がレビューするのは **設計書（spec.md）** と **テスト仕様書（test-spec.md）** のみ
- Claude Code が設計書を読んで、E2Eテスト → コードの順で実装する（TDD）
- 会話ログは自動保存され、分析に活用できる

---

## セットアップ

### 1. このテンプレートからリポジトリを作成する

GitHub の「Use this template」からリポジトリを作成してください。

### 2. Claude Code でプロジェクトを開く

```bash
claude
```

### 3. /init を実行する

```
/init
```

技術スタックを自動検出し、`CLAUDE.md` を補完します。`docs/inception/` の各ファイルに、プロダクトの目的・ターゲットユーザー・ドメイン定義・セキュリティ規約を記入してください。

---

## 開発フロー

### 基本：/develop（推奨）

1つのコマンドで設計書生成 → レビュー → テスト仕様生成 → レビュー → 実装 まで一気通貫で進みます。

```
/develop [機能名]
```

**例：**

```
/develop user-auth
```

フローは以下の通りです：

```
/develop user-auth
    │
    ├─ Claude が spec.md を生成
    │      ↓ レビュー・承認（「OK」と送信）
    │
    ├─ Claude が test-spec.md を生成
    │      ↓ レビュー・承認（「OK」と送信）
    │
    └─ Claude が E2Eテスト → コードを実装
```

人間がやることは **「OK」と送信するだけ**です。

---

### 個別コマンド

特定のステップだけやり直したい場合に使います。

| コマンド | 役割 |
|---|---|
| `/new-feature [名前]` | spec.md だけ生成する |
| `/new-test-spec [名前]` | test-spec.md だけ生成する |
| `/implement [名前]` | 実装だけやり直す |

**例：spec.md を修正した後に実装だけやり直す**

```
/implement user-auth
```

---

## ディレクトリ構成

```
.
├── CLAUDE.md                        # Claude への規約・スタック定義
├── .claude/
│   ├── settings.json                # 会話ログ自動保存フック
│   ├── scripts/
│   │   └── save-log.sh
│   └── commands/
│       ├── init.md                  # /init
│       ├── develop.md               # /develop
│       ├── new-feature.md           # /new-feature
│       ├── new-test-spec.md         # /new-test-spec
│       └── implement.md             # /implement
├── docs/
│   ├── inception/                   # プロジェクト全体のドキュメント
│   │   ├── requirements.md          # プロダクト要件・ビジネスルール
│   │   ├── domain-model.md          # 用語定義・エンティティ
│   │   └── security-policy.md       # 横断的なセキュリティ・パフォーマンス規約
│   ├── _templates/                  # 設計書テンプレート
│   │   ├── feature.md
│   │   └── test-spec.md
│   └── features/                    # 機能ごとの設計書（自動生成）
│       └── [機能名]/
│           ├── spec.md              # 設計書（レビュー対象①）
│           ├── test-spec.md         # テスト仕様書（レビュー対象②）
│           └── status.md            # 実装状況（Claude が更新）
└── logs/                            # 会話ログ（.gitignore 済み）
    └── YYYY-MM-DD/
        └── [session-id].jsonl
```

---

## 設計書の構成

### spec.md（レビュー対象①）

機能の仕様を定義します。Claude が叩き台を生成し、人間がレビュー・修正します。

- 概要・ユーザーストーリー
- API定義（tRPC / GraphQL）
- データモデル
- 画面・コンポーネント
- 制約・ビジネスルール
- **機能固有のセキュリティ・パフォーマンス要件**
- 未解決事項

### test-spec.md（レビュー対象②）

E2Eテストのケースを定義します。spec.md をもとに Claude が生成します。

- 正常系テストケース
- 異常系テストケース
- セキュリティテストケース（認証・認可・入力バリデーション）
- パフォーマンステストケース

Claude はこの test-spec.md から E2E テストコードを生成し、それが通るようにコードを実装します。

---

## インセプションドキュメント

`docs/inception/` はプロジェクト全体の文脈を定義します。Claude はすべての設計書生成・実装の前にこれらを読みます。

| ファイル | 内容 | 更新タイミング |
|---|---|---|
| `requirements.md` | プロダクトの目的・対象ユーザー・ビジネスルール | 方針変更時 |
| `domain-model.md` | エンティティ・用語定義 | 新機能で新概念が登場したとき |
| `security-policy.md` | 全機能共通のセキュリティ・パフォーマンス規約 | 規約変更時 |

---

## 会話ログ

Claude Code の応答が終わるたびに、セッションログが自動的に `logs/YYYY-MM-DD/` に保存されます。ログは JSONL 形式で、Claude による分析を想定しています。

ログは `.gitignore` に含まれているため、リポジトリには含まれません。
