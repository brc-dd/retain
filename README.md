# Retain

An opinionated backup script for macOS to backup your data to iCloud Drive.

## Features

- Generates a file list based on `include.txt` and `exclude.txt`.
- Dumps global Homebrew packages via `brew bundle dump`.
- Archives files into a ZIP and moves it to your iCloud Drive.
- Runs automatically as a LaunchAgent at 9:00 AM daily.

## Requirements

- macOS
- [fd](https://github.com/sharkdp/fd)
- [Homebrew](https://brew.sh/) (for `brew bundle`)
- [mas](https://github.com/mas-cli/mas) (optional, but recommended if you want to include App Store
  apps in Brewfile)

## Installation

Clone the repository and run the installer:

```bash
# brew install fd mas
git clone git@github.com:brc-dd/retain.git ~/.retain
cd ~/.retain
./install.sh
```

This will generate a LaunchAgent plist at `~/Library/LaunchAgents/dev.brc-dd.retain.plist` and load
it to schedule automatic backups.

To verify the installation, check if the LaunchAgent is loaded:

```bash
launchctl list | grep dev.brc-dd.retain
```

To check if the LaunchAgent is working, you can kickstart it manually:

```bash
launchctl kickstart -k gui/$(id -u)/dev.brc-dd.retain
```

You can view the logs using:

```bash
cat /tmp/retain.log # or tail -f /tmp/retain.log
cat /tmp/retain.err # or tail -f /tmp/retain.err
```

## Usage

- **Manual backup**:
  ```bash
  cd ~/.retain
  ./main.sh
  ```
- **Customize backup contents**: edit `include.txt` and `exclude.txt` to adjust which files are
  included or skipped.
- **Backup output**: the archive `backup.zip` is placed in your iCloud Drive:
  `~/Library/Mobile Documents/com~apple~CloudDocs/backup.zip`

## Uninstallation

To unload and remove the LaunchAgent:

```bash
cd ~/.retain
./uninstall.sh
```

## Development

- Use `dump.sh` to regenerate `include.txt` from
  [mackup/applications](https://github.com/lra/mackup/tree/master/mackup/applications). Needs `pnpm`
  to be installed.
- The LaunchAgent template is in `retain.plist.template`.

## Sponsors

<p align="center">
  <a href="https://cdn.jsdelivr.net/gh/brc-dd/static/sponsors.svg">
    <img alt="brc-dd's sponsors" src='https://cdn.jsdelivr.net/gh/brc-dd/static/sponsors.svg'/>
  </a>
</p>
