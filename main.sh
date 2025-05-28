#!/usr/bin/env bash
set -euo pipefail

# 1) Load include patterns (preserving spaces) into an array
include=()
while IFS= read -r line || [[ -n "$line" ]]; do
  # trim leading/trailing whitespace, keep internal spaces
  trimmed="${line#"${line%%[![:space:]]*}"}"
  trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
  [[ -n "$trimmed" ]] && include+=("$trimmed")
done <./include.txt

# 2) Load exclude patterns into fd flags (also preserving spaces)
fd_excludes=()
while IFS= read -r line || [[ -n "$line" ]]; do
  trimmed="${line#"${line%%[![:space:]]*}"}"
  trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
  [[ -n "$trimmed" ]] && fd_excludes+=(--exclude "$trimmed")
done <./exclude.txt

# 3) Dump your global Brewfile to keep track of installed packages
HOMEBREW_NO_AUTO_UPDATE=1 brew bundle dump --global --force

# 4) Find all files under $HOME (excluding dirs, symlinks, and your exclude patterns),
#    then append their paths (relative to $HOME) to the include list
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

# 5) Write the combined list to ~/.retain/backup.txt
printf '%s\n' "${include[@]}" >~/.retain/backup.txt

echo "Backup list created at ~/.retain/backup.txt"

# 6) Create the zip archive from that list
cd "$HOME"
rm -f .retain/backup.zip

# initialize so $zip_code is never unset
zip_code=0

# run zip; if it fails, assign its exit code to $zip_code (but don't exit the script)
zip -r .retain/backup.zip -@ <.retain/backup.txt || zip_code=$?

# now check: only 0 and 18 are OK
if [[ $zip_code -ne 0 && $zip_code -ne 18 ]]; then
  echo "zip failed with exit code $zip_code" >&2
  exit $zip_code
fi

# 7) Move the archive into iCloud Drive
mv -f ~/.retain/backup.zip \
  ~/Library/Mobile\ Documents/com~apple~CloudDocs/backup.zip

echo "Backup created and moved to iCloud Drive."
