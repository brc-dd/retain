# Retain

**Retain** is an automated, opinionated backup tool designed for macOS that archives your important files to iCloud Drive on a nightly basis.

## 🚀 Features

- **Automated Backups:** Creates daily backups of your home directory excluding system and unnecessary files.
- **Customizable:** Configure your backup scope easily via custom `include.txt` and `exclude.txt`.
- **Homebrew Integration:** Automatically dumps your global Homebrew package list for easy restoration.
- **Seamless iCloud Integration:** Archives your data to a ZIP file stored directly in your iCloud Drive.
- **Scheduled Execution:** Runs automatically as a LaunchAgent daily at 9:00 AM.

## 📦 Requirements

- macOS
- [Homebrew](https://brew.sh/)

## 🛠 Installation

Install Retain via Homebrew Cask:

```bash
brew tap brc-dd/retain https://github.com/brc-dd/retain
brew install --no-quarantine --cask retain
```

Your backups will appear at:

```
~/Library/Mobile Documents/com~apple~CloudDocs/Retain/backup-[ComputerName].zip
```

## 🗂 Configuration

Retain allows detailed customization of backup behavior through two files located in `~/.config/retain/`:

- `include.txt`: List paths relative to your home directory to explicitly include in the backup.
- `exclude.txt`: Specify glob patterns to exclude from the backup process.

### How it works

- By default, Retain includes most files from your home directory but excludes system files, caches, temporary files, vendor directories, and directories already synced by iCloud Drive (e.g., `Documents`, `Desktop` — [See Apple Support](https://support.apple.com/en-in/109344)).
- Patterns specified in `exclude.txt` only apply within your home directory and cannot override paths explicitly added in `include.txt`.
- To backup directories typically not included, like your `Downloads` folder, you must explicitly add `Downloads` to your `include.txt`.
- These patterns are merged with the default patterns provided by Retain, allowing you to customize your backup without losing the default behavior.

You can use the following default files for reference:

- [include.txt](./Retain.app/Contents/Resources/include.txt)
- [exclude.txt](./Retain.app/Contents/Resources/exclude.txt)

## 🖥 Monitoring Logs

Check logs to monitor backup operations:

```bash
tail -f /tmp/retain.log
tail -f /tmp/retain.err
```

## ♻️ Uninstallation

To remove Retain completely:

```bash
brew uninstall --zap --cask retain
```

## 🔧 Development

Update backup includes, regenerate the archive, and update the Homebrew Cask using:

```bash
./prepare.sh
```

This script requires `pnpm`.

## 🙌 Sponsors

<p align="center">
  <a href="https://cdn.jsdelivr.net/gh/brc-dd/static/sponsors.svg">
    <img alt="brc-dd's sponsors" src="https://cdn.jsdelivr.net/gh/brc-dd/static/sponsors.svg" />
  </a>
</p>
