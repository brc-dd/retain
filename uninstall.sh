#!/bin/bash

PLIST_TARGET="$HOME/Library/LaunchAgents/dev.brc-dd.retain.plist"

echo "Uninstalling Retain LaunchAgent..."

launchctl unload "$PLIST_TARGET"
rm -f "$PLIST_TARGET"

echo "LaunchAgent unloaded and removed."
