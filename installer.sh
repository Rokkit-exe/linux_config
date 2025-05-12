#!/bin/bash

source ./functions.sh
source ./packages.sh

cat ./ascii.txt
echo
echo "Welcome to the Arch Linux Installer Script!"

# Check if running on Arch based system
if [ ! -f /etc/arch-release ]; then
  echo "This script is intended for Arch Linux or Arch-based systems."
  exit 1
fi

helper=$(options "AUR Helper" HELPER)
message "Configuring AUR Helper"
case "$helper" in
"paru")
  install_helper paru
  ;;
"yay")
  install_helper yay
  ;;
*)
  echo "skipping installation of AUR Helper"
  ;;
esac

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

configuration "LazyVim" configure_lazy
configuration "Storage drive" configure_drive
configuration "USB Wakeup" configure_wakeup
configuration "Cider V2" configure_cider
configuration "ZSH / Oh-My-Zsh" configure_zsh
