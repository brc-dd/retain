cask "retain" do
  version "20250529130547"
  sha256 "ad53b8f5be90b9a2f15f40e1fa634390354264aedc4e947953b254e1a70d615c"

  url "https://raw.githubusercontent.com/brc-dd/retain/refs/heads/main/Retain-ad53b8f5.zip"
  name "Retain"
  desc "Automated nightly iCloud-Drive backup"
  homepage "https://github.com/brc-dd/retain"

  depends_on formula: "fd"
  depends_on formula: "mas"

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

  uninstall launchctl: "dev.brc-dd.retain",
            quit:      "dev.brc-dd.retain",

  zap trash: [
    "~/Library/Application Support/Retain",
    "/tmp/retain.log",
    "/tmp/retain.err",
  ]
end
