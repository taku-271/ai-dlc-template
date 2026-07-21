# AI-DLC テンプレート

[AI-DLC（AI-Driven Development Lifecycle）](https://aws.amazon.com/jp/blogs/news/ai-driven-development-life-cycle/) をベースに、**人間が設計書だけをレビューし、Claude Code がコードを実装する**開発フローのテンプレートです。

## コンセプト

- 人間はコードを書かない・レビューしない
- 人間がレビューするのは **設計書（spec.md）** と **テスト仕様書（test-spec.md）** のみ
- Claude Code が設計書を読んで、E2Eテスト → コードの順で実装する（TDD）
- 会話ログは自動保存され、分析に活用できる

---

## セットアップ

### パターン A：新規リポジトリ（GitHub テンプレートから）

GitHub の「Use this template」からリポジトリを作成してください。

### パターン B：既存リポジトリへインストール

```bash
bash /path/to/ai-dlc-template/install.sh /path/to/your-repo
```

`.claude/`・`CLAUDE.md`・`docs/inception/`・`docs/_templates/` をコピーします。  
既存ファイルは上書き前に確認プロンプトが表示されます。

### 最後に：Claude Code で /init を実行する

```bash
claude  # 対象リポジトリで起動
```

```
/init
```

技術スタックを自動検出し、`CLAUDE.md` を補完します。`docs/inception/` の各ファイルに、プロダクトの目的・ターゲットユーザー・ドメイン定義・セキュリティ規約を記入してください。

---

## 開発フロー

### 基本：/feature-flow（推奨）

1つのコマンドで設計書生成 → テスト仕様生成 → 実装まで一気通貫で進みます。

```
/feature-flow [機能名 または やりたいことの説明]
```

**例：**

```
/feature-flow このアプリケーションにログイン機能を追加したい
```

機能名は `user-auth` のような kebab-case でも、上記のような自然文でも構いません。自然文の場合は Claude が内容から適切な機能名（例: `user-auth`）を決めて `docs/features/[機能名]/` 以下に設計書を作成します。

タスクサイズによってフローが変わります：

```
/feature-flow このアプリケーションにログイン機能を追加したい（Small判定）
    │
    ├─ Claude が spec.md を生成
    ├─ Claude が test-spec.md を生成
    └─ Claude が E2Eテスト → コードを実装
           ↓
     完了報告（ここで人間がまとめてレビュー）
```

```
/feature-flow このアプリケーションにログイン機能を追加したい（Medium/Large判定）
    │
    ├─ Claude が spec.md を生成
    │      ↓ レビュー・承認（「OK」と送信）
    │
    ├─ Claude が test-spec.md を生成
    │      ↓ レビュー・承認（「OK」と送信）
    │
    └─ Claude が E2Eテスト → コードを実装
```

Small（影響ファイル1〜3・実装1日以内）と判定されたタスクは承認待ちなしで自動的に完走し、完了報告の時点で事後レビューします。Medium/Large は各ステップで人間の承認（「OK」の送信）を得てから進みます。どちらの場合も spec.md・test-spec.md・status.md は必ず生成されます。

---

### 個別コマンド

特定のステップだけやり直したい場合に使います。

| コマンド | 役割 |
|---|---|
| `/new-feature [名前]` | spec.md だけ生成する |
| `/new-test-spec [名前]` | test-spec.md だけ生成する |
| `/implement [名前]` | 実装だけやり直す |
| `/fix [バグの概要]` | バグ修正（spec.md なし・原因特定→失敗テスト→修正） |
| `/review-apply [PR番号]` | PRのレビュー指摘を理解・修正し `.learnings/` に保存する |

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
│   └── skills/
│       ├── init/SKILL.md            # /init
│       ├── feature-flow/SKILL.md    # /feature-flow
│       ├── new-feature/SKILL.md     # /new-feature
│       ├── new-test-spec/SKILL.md   # /new-test-spec
│       ├── implement/SKILL.md       # /implement
│       ├── fix/SKILL.md             # /fix
│       └── review-apply/SKILL.md    # /review-apply
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
