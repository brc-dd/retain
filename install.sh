#!/bin/bash

set -euo pipefail

PLIST_TEMPLATE="retain.plist.template"
PLIST_TARGET="$HOME/Library/LaunchAgents/dev.brc-dd.retain.plist"
SCRIPT_PATH="$HOME/.retain/main.ts"
SCRIPT_DIR=$(dirname "$SCRIPT_PATH")

echo "🔍 Finding Deno..."
DENO_PATH=$(which deno)

if [ ! -x "$DENO_PATH" ]; then
  echo "❌ Deno not found in PATH. Please install Deno first."
  exit 1
fi

echo "📄 Generating LaunchAgent plist..."
sed -e "s|__DENO_PATH__|$DENO_PATH|g" \
  -e "s|__SCRIPT_PATH__|$SCRIPT_PATH|g" \
  -e "s|__SCRIPT_DIR__|$SCRIPT_DIR|g" \
  "$PLIST_TEMPLATE" >"$PLIST_TARGET"

chmod 644 "$PLIST_TARGET"

echo "⚙️ Loading Retain LaunchAgent..."
launchctl unload "$PLIST_TARGET" 2>/dev/null || true
launchctl load "$PLIST_TARGET"

echo "✅ Installed and loaded:"
echo "$PLIST_TARGET"
