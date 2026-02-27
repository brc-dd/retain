cask "retain" do
  version "20260227120818"
  sha256 "8df3a1ab66e27cee5208686f7dee45bbc839bf502cb5cdbd40a8a9c96c79059a"

  url "https://raw.githubusercontent.com/brc-dd/retain/refs/heads/main/Retain-8df3a1ab.zip"
  name "Retain"
  desc "Automated nightly iCloud drive backup"
  homepage "https://github.com/brc-dd/retain"

  depends_on formula: %w[fd mas]

  app "Retain.app"

  postflight do
    plist_path = File.expand_path("~/Library/LaunchAgents/dev.brc-dd.retain.plist")
    app_path = "#{appdir}/Retain.app"

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

  uninstall launchctl: "dev.brc-dd.retain",
            quit:      "dev.brc-dd.retain"

  zap trash: [
    "~/Library/Application Support/Retain",
    "#{ENV["XDG_CONFIG_HOME"] || '~/.config'}/retain",
    "/tmp/retain.log",
    "/tmp/retain.err",
  ]
end
