#!/bin/bash

set -euo pipefail

# Download applications directory
pnpx degit lra/mackup/mackup/applications applications --force # hangs on npx 11

# Output file
OUTPUT_FILE="include.txt"
: >"$OUTPUT_FILE"

# Parse each config file
for cfg in applications/*; do
  current_section=""
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Clean line (remove comments, trim)
    clean_line=$(echo "$line" | sed 's/#.*//' | awk '{$1=$1; print}')
    [[ -z "$clean_line" ]] && continue

    # Section headers
    if [[ "$clean_line" =~ ^\[.*\]$ ]]; then
      current_section="$clean_line"
      continue
    fi

    # Match and output file paths
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

# Extra paths
echo 'Library/Application Support/Arc/User Data' >>"$OUTPUT_FILE"

# Keep only Library/ paths
grep '^Library/' "$OUTPUT_FILE" | sort -u >"$OUTPUT_FILE.tmp"
mv "$OUTPUT_FILE.tmp" "$OUTPUT_FILE"
