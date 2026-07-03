#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── 引数チェック ──────────────────────────────────────────────
if [[ $# -lt 1 ]]; then
  echo "Usage: bash install.sh <target-repo-path>"
  exit 1
fi

TARGET="$(cd "$1" && pwd)"

if [[ ! -d "$TARGET/.git" ]]; then
  echo "Error: $TARGET is not a git repository."
  exit 1
fi

echo "Installing AI-DLC template into: $TARGET"
echo ""

# ── ユーティリティ ────────────────────────────────────────────
confirm_overwrite() {
  local path="$1"
  if [[ -e "$path" ]]; then
    read -r -p "  Overwrite $path? [y/N] " answer
    [[ "$answer" =~ ^[Yy]$ ]] || return 1
  fi
  return 0
}

copy_item() {
  local src="$1"
  local dst="$2"

  if [[ -e "$dst" ]]; then
    read -r -p "  Overwrite $(basename "$dst")? [y/N] " answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
      echo "  Skipped: $dst"
      return
    fi
  fi

  if [[ -d "$src" ]]; then
    mkdir -p "$dst"
    cp -r "$src/." "$dst/"
  else
    cp "$src" "$dst"
  fi
  echo "  Copied:  $dst"
}

# ── ファイルコピー ────────────────────────────────────────────
echo "[1/6] Copying .claude/ ..."
copy_item "$TEMPLATE_DIR/.claude" "$TARGET/.claude"

echo ""
echo "[2/6] Copying CLAUDE.md ..."
copy_item "$TEMPLATE_DIR/CLAUDE.md" "$TARGET/CLAUDE.md"

echo ""
echo "[3/6] Copying docs/ ..."
mkdir -p "$TARGET/docs"
copy_item "$TEMPLATE_DIR/docs/inception"  "$TARGET/docs/inception"
copy_item "$TEMPLATE_DIR/docs/_templates" "$TARGET/docs/_templates"

echo ""
echo "[4/6] Copying .learnings/ ..."
copy_item "$TEMPLATE_DIR/.learnings" "$TARGET/.learnings"

echo ""
echo "[5/6] Copying .steering/ ..."
copy_item "$TEMPLATE_DIR/.steering" "$TARGET/.steering"

echo ""
echo "[6/6] Creating logs/ directory ..."
mkdir -p "$TARGET/logs"
echo "  Created: $TARGET/logs/"

# ── .gitignore 更新 ──────────────────────────────────────────
GITIGNORE="$TARGET/.gitignore"
if [[ ! -f "$GITIGNORE" ]] || ! grep -qx "logs/" "$GITIGNORE"; then
  echo "" >> "$GITIGNORE"
  echo "logs/" >> "$GITIGNORE"
  echo "  Updated: $GITIGNORE (added logs/)"
fi

# ── 完了 ─────────────────────────────────────────────────────
echo ""
echo "Done. Next step: open the repo in Claude Code and run /init"
