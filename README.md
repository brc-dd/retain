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

Retain is available via Homebrew Cask. First tap the repository and install:

```bash
brew tap brc-dd/retain https://github.com/brc-dd/retain
brew install --no-quarantine --cask retain
```

This will install Retain.app into your Applications directory, run it once to prompt for Full Disk
Access, and set up the LaunchAgent to schedule automatic backups.

The backup archive will be placed in your iCloud Drive at `Retain/backup-[ComputerName].zip`.

You can view the logs using:

```bash
tail -f /tmp/retain.log
tail -f /tmp/retain.err
```

## Uninstallation

```bash
brew uninstall --zap --cask retain
```

## Development

- Use `prepare.sh` to update the include list from
  [mackup/applications](https://github.com/lra/mackup/tree/master/mackup/applications) and generate
  the zip archive and update the cask. Needs `pnpm` to be installed.

## Sponsors

<p align="center">
  <a href="https://cdn.jsdelivr.net/gh/brc-dd/static/sponsors.svg">
    <img alt="brc-dd's sponsors" src='https://cdn.jsdelivr.net/gh/brc-dd/static/sponsors.svg'/>
  </a>
</p>
