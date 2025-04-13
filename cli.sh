#!/bin/bash

# Exit on error
set -e

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi
# Check if the script is run on Ubuntu
if [ ! -f /etc/os-release ]; then
    echo "This script is intended for Ubuntu only."
    exit 1
fi

source ./functions.sh

# Updating before Installing
echo "------------------------------------------------------------------------"
echo "Updating package list..."
sleep 1

apt update && apt full-upgrade -y


PACKAGES=(
    "build-essential" "C/C++ development tools" ON
    "ca-certificates" "Trusted CA certs" ON
    "bluetooth" "Bluetooth support" ON
    "pkg-config" "Library compile helper" ON
    "os-prober" "Detect other OSes" ON
    "neofetch" "System info at terminal" ON
    "htop" "Interactive process viewer" ON
    "powertop" "Power optimization tool" ON
    "lm-sensors" "Detect hardware sensors" ON
    "gnupg" "GPG encryption tools" ON
    "lsb-release" "Distro info tool" ON
    "wget" "File downloader" ON
    "curl" "URL tool" ON
    "git" "Version control system" ON
)

# Create the checklist
CHOICES=$(whiptail --title "Essential Package Installer" --checklist \
"Select packages to install:" 25 70 18 \
"${PACKAGES[@]}" \
3>&1 1>&2 2>&3)

LANGUAGE=(
    "python3.12" "Python 3.12" ON
    "dotnet-sdk-8.0" ".NET SDK 8.0" ON
    "golang" "Go programming language" ON
    "bun" "Bun JavaScript runtime" ON
    "nodejs" "Node.js" OFF
    "java" "Java Development Kit 20" OFF
    "kotlin" "Kotlin programming language" OFF
    "rust" "Rust programming language" OFF
    "php" "PHP programming language" OFF
)

BROWSER=(
    "brave" "Brave web browser" ON
    "firefox" "Firefox web browser" OFF
    "chromium-browser" "Chromium web browser" OFF
    "google-chrome-stable" "Google Chrome" OFF
    "microsoft-edge-stable" "Microsoft Edge" OFF
    "opera-stable" "Opera web browser" OFF
    "vivaldi-stable" "Vivaldi web browser" OFF
    "tor-browser" "Tor web browser" OFF
    "zen" "Zen web browser" OFF
)

DEV=(
    "docker" "Container engine" ON
    "beekeeper-studio" "Database management" ON
    "postman" "API development" ON
)

CODE_EDITOR=(
    "vscode" "Code editor" ON
    "neovim" "Code editor" ON
    "vim" "Text editor" ON
    "Pycharm" "Code editor for Python" OFF
    "Intellij-Idea" "Code editor for Java/Kotlin" OFF
)

MEDIA=(
    "discord" "Chat and video app" ON
    "obs-studio" "Video recording and streaming" ON
    "obsidian" "Note-taking app" ON
    "vlc" "Media player" ON
    "rhythmbox" "Music player" OFF
)

AI=(
    "ollama" "AI model runner" ON
)

GNOME=(
    "dconf-editor" "GNOME settings editor" ON
    "gnome-tweaks" "Tweak GNOME desktop" ON
)

CHOICES=$(whiptail --title "Package Manager" --checklist \
"Choose packages to install or uninstall:" 20 78 10 \
"brave" "Web browser" ON \
"vscode" "Code editor" ON \
"docker" "Container engine" ON \
"twingate" "Zero trust network access" ON \
"beekeeper-studio" "Database management" ON \
"ollama" "AI model runner" ON \

"impression" "Image viewer" ON \
"postman" "API development" ON \

3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus != 0 ]; then
  echo "User canceled."
  exit 1
fi

SELECTED=()
for pkg in $CHOICES; do
  SELECTED+=("${pkg//\"/}")
done

# Install selected packages
if [ ${#SELECTED[@]} -gt 0 ]; then
    echo "Installing..."
    sudo apt update
    sudo apt install -y "${SELECTED[@]}"
else
    echo "No packages selected."
fi

# Convert the selected values to an array
SELECTED=($CHOICES)

echo "Selected options:"
for choice in "${SELECTED[@]}"; do
    echo " - $choice"
    # Example uninstall command:
    case $choice in
        "\"ollama\"")
        echo "Uninstalling ollama..."
        ;;
        "\"docker\"")
        echo "Uninstalling docker..."
        ;;
        "\"git\"")
        echo "Uninstalling git..."
        ;;
        "\"neofetch\"")
        echo "Uninstalling neofetch..."
        ;;
    esac
done