#!/usr/bin/env bash

set -euo pipefail

pnpx degit lra/mackup/mackup/applications applications --force

OUTPUT_FILE="include.txt"
: >"$OUTPUT_FILE"

for cfg in applications/*; do
  current_section=""
  while IFS= read -r line || [[ -n "$line" ]]; do
    clean_line=$(echo "$line" | sed 's/#.*//' | awk '{$1=$1; print}')
    [[ -z "$clean_line" ]] && continue

    if [[ "$clean_line" =~ ^\[.*\]$ ]]; then
      current_section="$clean_line"
      continue
    fi

    case "$current_section" in
    "[configuration_files]")
      echo "$clean_line" >>"$OUTPUT_FILE"
      ;;
    # "[xdg_configuration_files]")
    #   echo ".config/$clean_line" >>"$OUTPUT_FILE"
    #   ;;
    esac
  done <"$cfg"
done

echo 'Library/Application Support/Arc/User Data' >>"$OUTPUT_FILE"

grep '^Library/' "$OUTPUT_FILE" | sort -u >"$OUTPUT_FILE.tmp"
mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"
