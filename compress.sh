#!/bin/sh
set -euo pipefail

APP_SRC=$1
OUTFILE=$2

OUTDIR=$(dirname "$OUTFILE")
OUTBASE=$(basename "$OUTFILE")
OUTDIR_ABS=$(cd "$OUTDIR" && pwd)
OUT_ABS="$OUTDIR_ABS/$OUTBASE"

TMP=$(mktemp -d)
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

cp -R "$APP_SRC" "$TMP/"
APP_NAME=$(basename "$APP_SRC")

find "$TMP/$APP_NAME" -exec touch -t 198001010000 {} +

cd "$TMP"
zip -r -X "$OUT_ABS" "$APP_NAME" >/dev/null
