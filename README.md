# Retain

An opinionated backup script for macOS to backup your data to iCloud Drive.

## Features

- Generates a file list based on `include.txt` and `exclude.txt`.
- Dumps global Homebrew packages via `brew bundle dump`.
- Archives files into a ZIP and moves it to your iCloud Drive.
- Runs automatically as a LaunchAgent at 9:00 AM daily.

## Requirements

- macOS
- [Deno](https://deno.land/)
- [Homebrew](https://brew.sh/) (for `brew bundle`)
- [mas](https://github.com/mas-cli/mas) (optional, but recommended if you want to include App Store apps in Brewfile)

## Installation

Clone the repository and run the installer:

```bash
git clone git@github.com:brc-dd/retain.git ~/.retain
cd ~/.retain
./install.sh
```

This will generate a LaunchAgent plist at `~/Library/LaunchAgents/dev.brc-dd.retain.plist` and load it to schedule automatic backups.

## Usage

- **Manual backup**:
  ```sh
  cd ~/.retain
  deno run -A main.ts
  ```
- **Customize backup contents**: edit `include.txt` and `exclude.txt` to adjust which files are included or skipped.
- **Backup output**: the archive `backup.zip` is placed in:\
  `~/Library/Mobile Documents/com~apple~CloudDocs/backup.zip`

## Uninstallation

To unload and remove the LaunchAgent:

```bash
cd ~/.retain
./uninstall.sh
```

## Development

- Use `dump.sh` to regenerate `include.txt` from [mackup/applications](https://github.com/lra/mackup/tree/master/mackup/applications).
- The LaunchAgent template is in `retain.plist.template`.

## License

MIT License
