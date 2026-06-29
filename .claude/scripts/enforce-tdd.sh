#!/bin/bash
# PreToolUse Hook: TDD強制 - テストなしで実装コードを書くことをブロックする
# （指示は「お願い」、このHookは「強制」）

FILE_PATH=$(echo "$CLAUDE_TOOL_INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('file_path',''))" 2>/dev/null || echo "")

# ファイルパスが取得できない場合はスキップ
if [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# テストファイル自体の書き込みはOK
if echo "$FILE_PATH" | grep -qiE '\.(test|spec)\.(ts|tsx|js|jsx|py|rb|go|rs)$|/__tests__/|/test_[^/]+\.(py|rb)$|/[^/]+_test\.(go|rs|py)$'; then
  exit 0
fi

# ドキュメント・設定・スクリプト類はスキップ
if echo "$FILE_PATH" | grep -qiE '\.(md|json|yaml|yml|toml|env|gitignore|sh|lock|css|scss|svg|png|jpg|ico|txt|d\.ts)$'; then
  exit 0
fi
if echo "$FILE_PATH" | grep -qE '^docs/|^\.claude/|^\.learnings/|^\.steering/|^public/|node_modules'; then
  exit 0
fi

# src/ など実装ディレクトリ配下のみチェック対象
if ! echo "$FILE_PATH" | grep -qE '(^|/)src/|(^|/)app/|(^|/)lib/|(^|/)pages/'; then
  exit 0
fi

# 対応するテストファイルを探す
BASENAME=$(python3 -c "import os; print(os.path.splitext(os.path.basename('$FILE_PATH'))[0])" 2>/dev/null || basename "$FILE_PATH" | sed 's/\.[^.]*$//')
DIRNAME=$(dirname "$FILE_PATH")
ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")

TEST_EXISTS=false

for pattern in \
  "${DIRNAME}/${BASENAME}.test.*" \
  "${DIRNAME}/${BASENAME}.spec.*" \
  "${DIRNAME}/__tests__/${BASENAME}.*" \
  "${ROOT}/tests/${BASENAME}.*" \
  "${ROOT}/test/${BASENAME}.*" \
  "$(echo "$DIRNAME" | sed 's|/src/|/tests/|g')/${BASENAME}.*" \
  "$(echo "$DIRNAME" | sed 's|/app/|/tests/|g')/${BASENAME}.*"
do
  if compgen -G "$pattern" > /dev/null 2>&1; then
    TEST_EXISTS=true
    break
  fi
done

if [[ "$TEST_EXISTS" == "false" ]]; then
  echo ""
  echo "🚫 TDD違反: テストファイルが存在しない状態で実装コードを書こうとしています。"
  echo ""
  echo "   対象ファイル: $FILE_PATH"
  echo "   期待されるテストファイル例:"
  echo "     - ${DIRNAME}/${BASENAME}.test.ts"
  echo "     - ${DIRNAME}/__tests__/${BASENAME}.ts"
  echo ""
  echo "   先にテストファイルを作成してから実装してください（TDD原則）。"
  echo ""
  exit 2
fi

exit 0
