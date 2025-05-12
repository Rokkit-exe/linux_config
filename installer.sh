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
if ! command -v yay &>/dev/null; then
  echo "yay is not installed."
  message "Installing yay..."
  # Install yay
  sudo pacman -S --needed git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  echo "yay is already installed."
fi

# Check if yay is installed
if ! command -v zenity &>/dev/null; then
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
  TRUE "etcher-bin"
)

# Define Pacman packages
PACMAN=(
  TRUE "neovim"
  TRUE "docker"
  TRUE "discord"
  TRUE "ollama"
  TRUE "go"
  TRUE "python"
  TRUE "mariadb"
  TRUE "numlockx"
  TRUE "curl"
  TRUE "wget"
  TRUE "htop"
  TRUE "powertop"
  TRUE "radeontop"
  TRUE "lm_sensors"
  TRUE "vlc"
  TRUE "steam"
  TRUE "qbittorrent"
  TRUE "neofetch"
  TRUE "thunderbird"
)

WAYLAND=(
  TRUE "hyprland"
  TRUE "hyprpaper"
  TRUE "hyprlock"
  TRUE "hypridle"
  TRUE "hyprshot"
  TRUE "hyprpicker"
  TRUE "waybar"
  TRUE "swaync"
  TRUE "wofi"
  TRUE "kitty"
  TRUE "ttf-font-awesome"
  TRUE "stow"
  TRUE "nwg-look"
  TRUE "pavucontrol"
  TRUE "pamixer"
  TRUE "thunar"
  TRUE "catppuccin-gtk-theme-mocha"
)

# Show zenity checklist for a group
select_packages() {
  local title="$1"
  local array_name="$2"
  declare -n packages="$array_name" # Reference the array

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
wayland_pkgs=$(select_packages "Install packages for wayland" WAYLAND)
aur_pkgs=$(select_packages "Install AUR Packages with yay" AUR)

# Parse selected packages into arrays
IFS="|" read -ra pacman_array <<<"$pacman_pkgs"
IFS="|" read -ra wayland_array <<<"$wayland_pkgs"
IFS="|" read -ra aur_array <<<"$aur_pkgs"

# Install
if [ ${#pacman_array[@]} -gt 0 ]; then install_with_pacman "${pacman_array[@]}"; fi
if [ ${#wayland_array[@]} -gt 0 ]; then install_with_pacman "${wayland_array[@]}"; fi
if [ ${#aur_array[@]} -gt 0 ]; then install_with_yay "${aur_array[@]}"; fi

echo -e "\n✅ All selected packages installed."

message "Neovim Configuration"
read -p "Would you like to install Lazy.vim ? (y/N): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
  echo "Installing Lazy.vim"
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
else
  echo "Skipping installation of Lazy.vim"
fi

message "Configuring mouted drives..."
read -p "Would you like to mount the storage drive? (y/N): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
  echo "Mounting storage drive..."
  sudo mkdir -p /mnt/storage
  echo "# /dev/sda" | sudo tee -a /etc/fstab >/dev/null
  echo "UUID=1aa44f69-7eed-4464-9b6f-8a847f9b8366 /mnt/storage   ext4    defaults,nofail  0   2" | sudo tee -a /etc/fstab >/dev/null
  sudo mount -a
  sudo systemctl daemon-reload
else
  echo "Skipping storage drive mount."
fi

message "Configuring USB wakeup..."
read -p "Would you like to disable USB wakeup? (y/N): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
  echo "Disabling USB wakeup for device XHC0, XHC1, XHC2..."
  # check /proc/acpi/wakeup to validate
  sudo cp disable-usb-wake.sh /usr/local/bin/disable-usb-wake.sh
  sudo chmod +x /usr/local/bin/disable-usb-wake.sh
  sudo cp disable-usb-wakeup.service /etc/systemd/system/disable-usb-wake.service
  sudo systemctl enable disable-usb-wake.service
  sudo systemctl start disable-usb-wake.service
  echo "USB wakeup disabled for device XHC0, XHC1, XHC2."
else
  echo "Skipping USB wakeup configuration."
fi

message "Installing Cider V2 from arch package"
read -p "Would you like to install Cider V2? (y/N): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
  if [[ -f "/mnt/storage/cider/cider-v2.0.3-linux-x64.pkg.tar.zst" ]]; then
    sudo pacman -U --noconfirm --needed /mnt/storage/cider/cider-v2.0.3-linux-x64.pkg.tar.zst
  else
    echo "Unable to find Cider v2 package in storage drive"
  fi
else
  echo "Skipping Cider installation"
fi

message "Configuring Shell"
read -p "Would you like to use ZSH instead of bash ? (y/N): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
  echo "Installing ZSH..."
  sudo pacman -S --noconfirm --needed zsh

  echo "Setting ZSH as default shell..."
  chsh -s $(which zsh)
  echo "ZSH installed and set as default shell."
else
  echo "Keeping bash as default shell."
fi

message "Configuring Oh-My-ZSH"
read -p "Would you like to install Oh-My-ZSH? (y/N): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
  echo "Installing Oh-My-ZSH..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "Oh-My-ZSH installed."
else
  echo "Skipping Oh-My-ZSH installation."
fi

read -p "Would you like to install ZSH plugins? (y/N): " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
  echo "Installing ZSH plugins: (zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, z)..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
  sed -i 's/plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions z)/' ~/.zshrc
  echo "autoload -Uz compinit" >>~/.zshrc
  echo "compinit" >>~/.zshrc
else
  echo "Skipping ZSH plugins installation."
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
