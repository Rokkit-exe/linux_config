#!/bin/bash

ESSENTIALS=(
    "Build Essential" "apt" "build-essential" ON
    "CA Certificates" "apt" "ca-certificates" ON
    "Bluetooth Support" "apt" "bluetooth" ON
    "Pkg Config" "apt" "pkg-config" ON
    "OS Prober" "apt" "os-prober" ON
    "Neofetch" "apt" "neofetch" ON
    "HTop" "apt" "htop" ON
    "PowerTop" "apt" "powertop" ON
    "LM Sensors" "apt" "lm-sensors" ON
    "GnuPG" "apt" "gnupg" ON
    "LSB Release" "apt" "lsb-release" ON
    "Plank" "apt" "plank" ON
    "Wget" "apt" "wget" ON
    "Curl" "apt" "curl" ON
    "Git" "apt" "git" ON
)

UTILITIES=(
    "Brave Browser" "func" "brave" ON
    "Firefox Browser" "apt" "firefox" OFF
    "Chromium Browser" "flatpak" "org.chromium.Chromium" OFF
    "Opera Browser" "flatpak" "com.opera.Opera" OFF
    "Tor Browser" "flatpak" "org.torproject.torbrowser-launcher" OFF
    "Zen Browser" "flatpak" "app.zen_browser.zen" OFF
    "Discord" "flatpak" "com.discordapp.Discord" ON
    "OBS Studio" "flatpak" "com.obsproject.Studio" ON
    "Obsidian" "flatpak" "md.obsidian.Obsidian" ON
    "VLC Media Player" "apt" "vlc" ON
    "Cider" "func" "cider" ON
    "Impression" "flatpak" "io.gitlab.adhami3310.Impression" ON
    "qBittorrent" "flatpak" "org.qbittorrent.qBittorrent" ON
    "Steam" "apt" "steam" ON
    "GIMP" "flatpak" "org.gimp.GIMP" OFF
    "Rhythmbox" "flatpak" "org.gnome.Rhythmbox3" OFF
    "Spotify" "flatpak" "com.spotify.Client" OFF
    "Telegram" "flatpak" "org.telegram.desktop" OFF
    "Signal" "flatpak" "org.signal.Signal" OFF
    "Slack" "flatpak" "com.slack.Slack" OFF
    "Zoom" "flatpak" "us.zoom.Zoom" OFF
    "Portal for Microsoft Teams" "flatpak" "com.github.IsmaelMartinez.teams_for_linux" OFF
    "Twingate" "func" "twingate" ON
    "ProtonVPN" "apt" "protonvpn" OFF
    "Tailscale" "apt" "tailscale" OFF
    "WireGuard" "apt" "wireguard" OFF
    "OpenVPN" "apt" "openvpn" OFF
)

DEVELOPMENT=(
    "VS Code" "func" "vscode" ON
    "Vim" "apt" "vim" ON
    "NeoVim" "apt" "neovim" ON
    "Docker" "func" "install_docker" ON
    "Beekeeper Studio" "func" "install_beekeeper-studio" ON
    "Postman" "flatpak" "com.getpostman.Postman" ON
    "Ollama" "func" "ollama" ON
    "PyCharm" "func" "pycharm" OFF
    "IntelliJ IDEA" "func" "intellij-idea" OFF
    "Python 3.12" "func" "python" ON
    "MariaDB" "apt" "mariadb-server" ON
    "MySQL" "apt" "mysql-server-8.0" OFF
    "Redis" "apt" "redis-server" OFF
    "SQLite" "apt" "sqlite3" OFF
    "PostgreSQL" "apt" "postgresql" OFF
    ".NET SDK 8.0" "apt" "dotnet-sdk-8.0" ON
    "Go Programming Language" "func" "golang" ON
    "Bun JavaScript Runtime" "func" "bun" ON
    "Node.js" "func" "nodejs" OFF
    "Java 20" "func" "java" OFF
    "Kotlin" "func" "kotlin" OFF
    "PHP 8.2" "func" "php" OFF
    "Rust" "func" "rust" OFF
)

CONFIGURATIONS=(
    "Oh My Posh - Craver" "func" "oh-my-posh" ON
    "Numlock on boot" "func" "numlock" ON
)
