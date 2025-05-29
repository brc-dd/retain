#!/bin/bash

set -euo pipefail

# Download applications directory
pnpx degit lra/mackup/mackup/applications applications --force # hangs on npx 11

# Output file
OUTPUT_FILE="Retain.app/Contents/Resources/include.txt"
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

# Prepare the cask
rm -f Retain-*.zip

./compress.sh Retain.app Retain.zip
zip_hash=$(shasum -a 256 "Retain.zip" | awk '{print $1}')
final_path="Retain-${zip_hash:0:8}.zip"
mv "Retain.zip" "$final_path"

sed -i '' "s/^  version .*/  version \"$(date +%Y%m%d%H%M%S)\"/" Casks/retain.rb
sed -i '' "s/^  sha256 .*/  sha256 \"${zip_hash}\"/" Casks/retain.rb
sed -i '' "s|^\(  url .*\)/Retain-.*\.zip|\\1/${final_path}|" Casks/retain.rb
