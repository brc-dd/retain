#!/usr/bin/env bash
set -euo pipefail

exec >>"/tmp/retain.log" 2>>"/tmp/retain.err"
export PATH="/opt/homebrew/bin:$PATH"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

resources_dir="$script_dir/../Resources"
include_file="$resources_dir/include.txt"
exclude_file="$resources_dir/exclude.txt"

data_dir="$HOME/Library/Application Support/Retain"
mkdir -p "$data_dir"

system_name=$(scutil --get ComputerName | tr ' ' '_')
icloud_dir="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Retain"
icloud_target="$icloud_dir/backup-${system_name}.zip"
mkdir -p "$icloud_dir"

include=()
while IFS= read -r line || [[ -n "$line" ]]; do
  trimmed="${line#"${line%%[![:space:]]*}"}"
  trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
  [[ -n "$trimmed" ]] && include+=("$trimmed")
done <"$include_file"

fd_excludes=()
while IFS= read -r line || [[ -n "$line" ]]; do
  trimmed="${line#"${line%%[![:space:]]*}"}"
  trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
  [[ -n "$trimmed" ]] && fd_excludes+=(--exclude "$trimmed")
done <"$exclude_file"

HOMEBREW_NO_AUTO_UPDATE=1 brew bundle dump --global --force

while IFS= read -r -d $'\0' file; do
  rel="${file#$HOME/}"
  include+=("$rel")
done < <(
  fd --unrestricted \
    --type f \
    --absolute-path \
    "${fd_excludes[@]}" \
    . "$HOME" \
    -0
)

backup_list="$data_dir/backup.txt"
printf '%s\n' "${include[@]}" >"$backup_list"

cd "$HOME"
backup_zip="$data_dir/backup.zip"
rm -f "$backup_zip"

zip_code=0
zip -r "$backup_zip" -@ <"$backup_list" || zip_code=$?

if [[ $zip_code -ne 0 && $zip_code -ne 18 ]]; then
  echo "Error: zip failed with exit code $zip_code" >&2
  exit $zip_code
fi

mv -f "$backup_zip" "$icloud_target"
echo "Backup successfully created at $icloud_target"
