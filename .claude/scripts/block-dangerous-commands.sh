#!/bin/bash
# PreToolUse Hook: 破壊的コマンドをブロックする
# CLAUDE.md の NEVER セクションに対応する「強制」層
# （CLAUDE.mdは「お願い」、このHookは「強制」）

COMMAND=$(echo "$CLAUDE_TOOL_INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('command',''))" 2>/dev/null || echo "")

# ブロック対象パターン
BLOCKED_PATTERNS=(
  "rm -rf"
  "git reset --hard"
  "git clean -f"
  "DROP TABLE"
  "TRUNCATE TABLE"
  "terraform destroy"
  "kubectl delete"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi "$pattern"; then
    echo "🚫 BLOCKED: '$pattern' は破壊的操作のためブロックしました。"
    echo "   実行が必要な場合は人間が直接ターミナルで実行してください。"
    exit 2  # exit 2 = Claude にエラーとして返す
  fi
done

exit 0
