#!/usr/bin/env bash
set -euo pipefail

exec >>"/tmp/retain.log" 2>>"/tmp/retain.err"
export PATH="/opt/homebrew/bin:$PATH"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

resources_dir="$script_dir/../Resources"
include_file="$resources_dir/include.txt"
exclude_file="$resources_dir/exclude.txt"

config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/retain"
user_include_file="$config_dir/include.txt"
user_exclude_file="$config_dir/exclude.txt"

data_dir="$HOME/Library/Application Support/Retain"
mkdir -p "$data_dir"

system_name=$(scutil --get ComputerName | tr ' ' '_')
icloud_dir="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Retain"
icloud_target="$icloud_dir/backup-${system_name}.zip"
mkdir -p "$icloud_dir"

read_file() {
  local file=$1
  local arr_name=$2
  if [[ -f "$file" ]]; then
    while IFS= read -r line || [[ -n "$line" ]]; do
      trimmed="${line#"${line%%[![:space:]]*}"}"
      trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
      if [[ -n "$trimmed" ]]; then
        eval "$arr_name+=(\"$trimmed\")"
      fi
    done <"$file"
  fi
}

include=()
read_file "$include_file" include
read_file "$user_include_file" include

fd_exclude_patterns=()
read_file "$exclude_file" fd_exclude_patterns
read_file "$user_exclude_file" fd_exclude_patterns

fd_excludes=()
for pattern in "${fd_exclude_patterns[@]}"; do
  fd_excludes+=(--exclude "$pattern")
done

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
zip -rq "$backup_zip" -@ <"$backup_list" || zip_code=$?

if [[ $zip_code -ne 0 && $zip_code -ne 18 ]]; then
  echo "Error: zip failed with exit code $zip_code" >&2
  exit $zip_code
fi

mv -f "$backup_zip" "$icloud_target"
echo "Backup successfully created at $icloud_target"
