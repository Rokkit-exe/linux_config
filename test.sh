#!/bin/bash

# Check dependencies
for cmd in zenity yay; do
    command -v $cmd >/dev/null 2>&1 || {
        echo "$cmd is not installed. Install it first."
        exit 1
    }
done

# Define AUR packages
AUR=(
    TRUE "brave-bin"
    TRUE "visual-studio-code-bin"
    TRUE "beekeeper-studio-bin"
    TRUE "postman-bin"
    TRUE "bun-bin"
    TRUE "oh-my-posh-bin"
    TRUE "twingate-bin"
)

# Define Pacman packages
PACMAN=(
    TRUE "vim"
    TRUE "neovim"
    TRUE "docker"
    TRUE "discord"
    TRUE "ollama"
    FALSE "gimp"
    FALSE "libreoffice-fresh"
    FALSE "intellij-idea-community-edition"
    FALSE "pycharm-community-edition"
    TRUE "go"
    TRUE "python"
    TRUE "dotnet-sdk-8.0"
    FALSE "nodejs"
    FALSE "jdk17-openjdk"
    FALSE "jdk20-openjdk"
    FALSE "kotlin"
    FALSE "php"
    FALSE "rustup"
    TRUE "mariadb"
    FALSE "mysql"
    FALSE "redis"
    FALSE "postgresql"
    TRUE "numlockx"
    TRUE "curl"
    TRUE "wget"
    TRUE "htop"
    TRUE "powertop"
    TRUE "lm_sensors"
    TRUE "gnupg"
    TRUE "ca-certificates"
    TRUE "vlc"
    TRUE "steam"
    TRUE "qbittorrent"
    TRUE "os-prober"
    TRUE "neofetch"
    TRUE "mesa-demos"
)

# Show zenity checklist for a group
select_packages() {
    local title="$1"
    local array_name="$2"
    declare -n packages="$array_name"  # Reference the array

    zenity --list \
        --title="$title" \
        --width=600 --height=600 \
        --text="Select packages to install:" \
        --checklist \
        --column="Install" \
        --column="Package" \
        "${packages[@]}" \
        --separator="|"
}

# Install selected packages
install_with_pacman() {
    for pkg in "$@"; do
        echo 
        echo "--------------------------------------------------------------------------------"
        echo "🔧 Installing $pkg with pacman..."
        sleep 1
        sudo pacman -S --noconfirm --needed "$pkg"
    done
}

install_with_yay() {
    for pkg in "$@"; do
        echo 
        echo "--------------------------------------------------------------------------------"
        echo "🌐 Installing $pkg from AUR with yay..."
        sleep 1
        yay -S --noconfirm "$pkg"
    done
}

# Run selection dialogs
pacman_pkgs=$(select_packages "Install Official (pacman) Packages" PACMAN)
aur_pkgs=$(select_packages "Install AUR Packages with yay" AUR)

# Parse selected packages into arrays
IFS="|" read -ra pacman_array <<< "$pacman_pkgs"
IFS="|" read -ra aur_array <<< "$aur_pkgs"

# Install
if [ ${#pacman_array[@]} -gt 0 ]; then install_with_pacman "${pacman_array[@]}"; fi
if [ ${#aur_array[@]} -gt 0 ]; then install_with_yay "${aur_array[@]}"; fi

echo -e "\n✅ All selected packages installed."
echo "Please restart your system to apply changes."
