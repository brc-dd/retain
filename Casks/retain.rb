cask "retain" do
  version "20250529113629"
  sha256 "d7d283e547bfdb762c6ba683699df43b5628649f8524b11493cb1c24a4798dfc"

  url "https://raw.githubusercontent.com/brc-dd/retain/refs/heads/main/Retain-20250529113629.zip"
  name "Retain"
  desc "Automated nightly iCloud-Drive backup"
  homepage "https://github.com/brc-dd/retain"

  depends_on formula: "fd"

  app "Retain.app"

  plist_path = File.expand_path("~/Library/LaunchAgents/dev.brc-dd.retain.plist")
  app_path = "#{appdir}/Retain.app"

  postflight do
    ohai "Running Retain once to prompt for permissions..."
    system_command "/usr/bin/open", args: ["-a", app_path]

    File.write(plist_path, <<~PLIST)
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>dev.brc-dd.retain</string>

        <key>ProgramArguments</key>
        <array>
          <string>/usr/bin/open</string>
          <string>-a</string>
          <string>#{app_path}</string>
        </array>

        <key>StartCalendarInterval</key>
        <dict>
          <key>Hour</key>
          <integer>9</integer>
          <key>Minute</key>
          <integer>0</integer>
        </dict>
      </dict>
      </plist>
    PLIST

    system_command "/bin/launchctl", args: ["load", "-w", plist_path]
  end

  uninstall launchctl: "dev.brc-dd.retain"

  zap trash: [
    "~/Library/Application Support/Retain",
    "/tmp/retain.log",
    "/tmp/retain.err",
  ]
end
