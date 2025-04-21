#!/bin/bash

cat ./ascii.txt
echo
echo "Welcome to the Arch Linux Installer Script!"

# Check if running on Arch based system
if [ ! -f /etc/arch-release ]; then
    echo "This script is intended for Arch Linux or Arch-based systems."
    exit 1
fi

message() {
    echo -e "\n--------------------------------------------------------------------------------"
    echo -e "🔧 $1"
    sleep 1
}

# Check dependencies
if ! command -v yay &> /dev/null; then
    echo "yay is not installed."
    message "Installing yay..."
    # Install yay
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Check if yay is installed
if ! command -v zenity &> /dev/null; then
    echo "zenity is not installed."
    message "Installing zenity..."

    # Install zenity
    sudo pacman -S --noconfirm --needed zenity
fi



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


# check if oh-my-posh is installed
if command -v oh-my-posh &> /dev/null; then
    echo "oh-my-posh is already installed."
    message "Configuring Oh-My-Posh with Theme: Craver and installing font: Firacode, Meslo..."
    echo 'eval "$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/craver.omp.json')"' >> ~/.bashrc

    oh-my-posh font install meslo
    oh-my-posh font install firacode
else
    echo "oh-my-posh is not installed."
fi


# check if sddm is installed
if [ -f /etc/sddm.conf ]; then
    echo "sddm is installed, configuring..."
    # Check if numlockx is installed
    if command -v numlockx &> /dev/null; then
        message "numlockx is installed, configuring..."
        # Enable numlockx for sddm
        sudo sed -i 's/^#NumLock=.*/NumLock=on/' /etc/sddm.conf
        echo "numlockx configured for sddm."
    else
        echo "numlockx is not installed"
    fi
else
    echo "sddm is not installed, skipping configuration for numlockx..."
fi


echo "--------------------------------------------------------------------------------"
echo "System needs to be rebooted for changes to take effect."
read -p "Do you want to reboot now? (y/N): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
    echo "Rebooting..."
    sleep 1
    sudo reboot
else
    echo "Reboot cancelled. Please reboot your system manually to apply changes."
fi

