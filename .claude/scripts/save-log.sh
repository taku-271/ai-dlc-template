#!/bin/bash
INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  DATE_DIR="logs/$(date +%Y-%m-%d)"
  mkdir -p "$DATE_DIR"
  SESSION_ID=$(basename "$TRANSCRIPT" .jsonl)
  cp "$TRANSCRIPT" "$DATE_DIR/${SESSION_ID}.jsonl"
fi
