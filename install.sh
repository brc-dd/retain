#!/usr/bin/env bash

PLIST_TEMPLATE="retain.plist.template"
PLIST_TARGET="$HOME/Library/LaunchAgents/dev.brc-dd.retain.plist"

echo "Installing Retain LaunchAgent..."

sed "s|__HOME__|$HOME|g" "$PLIST_TEMPLATE" >"$PLIST_TARGET"

chmod 644 "$PLIST_TARGET"

launchctl load "$PLIST_TARGET"

echo "LaunchAgent installed and loaded:"
echo "$PLIST_TARGET"
