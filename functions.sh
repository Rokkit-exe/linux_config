#!/bin/bash

#zenity functions
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

# list of radio buttons for zenity
options() {
  local title="$1"
  local array_name="$2"
  declare -n choices="$array_name"

  zenity --list \
    --title="$title" \
    --width=600 --height=600 \
    --text="Select an option:" \
    --radiolist \
    --column="Install" \
    --column="Package" \
    "${choices[@]}" \
    --separator="|"
}

# message functions

message() {
  local OPTIONS

  echo -e "\n--------------------------------------------------------------------------------"
  echo -e "🔧 $1"
  sleep 1
}

# Check if yay is installed
install_zenity() {
  if ! command -v zenity &>/dev/null; then
    echo "zenity is not installed."
    message "Installing zenity..."

    # Install zenity
    sudo pacman -S --noconfirm --needed zenity
  fi
}

# Configuration functions
install_helper() {
  message "Installing paru..."
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/$1.git
  cd $1
  makepkg -si --noconfirm
  cd ..
  rm -rf $1
  echo "$1 is installed"
}

configuration() {
  local title="$1"
  local function="$2"

  message "$title Installation/Configuration"
  choice=$(options "$title Installation/Configuration" BOOL)
  if [[ $choice == "Yes" ]]; then
    "$function"
  else
    echo "Skipping installation of LazyVim"
  fi
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

install_cider() {
  if [[ -f "/mnt/storage/cider/cider-v2.0.3-linux-x64.pkg.tar.zst" ]]; then
    sudo pacman -U --noconfirm --needed /mnt/storage/cider/cider-v2.0.3-linux-x64.pkg.tar.zst
  else
    echo "Unable to find Cider v2 package in storage drive"
  fi
}

configure_drive() {
  echo "Mounting storage drive..."
  sudo mkdir -p /mnt/storage
  echo "# /dev/sda" | sudo tee -a /etc/fstab >/dev/null
  echo "UUID=1aa44f69-7eed-4464-9b6f-8a847f9b8366 /mnt/storage   ext4    defaults,nofail  0   2" | sudo tee -a /etc/fstab >/dev/null
  sudo mount -a
  sudo systemctl daemon-reload
}

configure_lazy() {
  echo "Installing Lazy.vim"
  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
}

configure_wakeup() {
  echo "Disabling USB wakeup for device XHC0, XHC1, XHC2..."
  # check /proc/acpi/wakeup to validate
  sudo cp disable-usb-wake.sh /usr/local/bin/disable-usb-wake.sh
  sudo chmod +x /usr/local/bin/disable-usb-wake.sh
  sudo cp disable-usb-wakeup.service /etc/systemd/system/disable-usb-wake.service
  sudo systemctl enable disable-usb-wake.service
  sudo systemctl start disable-usb-wake.service
  echo "USB wakeup disabled for device XHC0, XHC1, XHC2."
}

configure_zsh() {
  echo "Installing ZSH..."
  sudo pacman -S --noconfirm --needed zsh

  echo "Setting ZSH as default shell..."
  chsh -s $(which zsh)
  echo "ZSH installed and set as default shell."

  echo "Installing Oh-My-ZSH..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "Oh-My-ZSH installed."

  echo "Installing ZSH plugins: (zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions, z)..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
  sed -i 's/plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions z)/' ~/.zshrc
  echo "autoload -Uz compinit" >>~/.zshrc
  echo "compinit" >>~/.zshrc

  echo "Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

  sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
}


configure_kitty() {
  if [[ ! command -v kitty &>/dev/null ]]; then
    echo "Kitty is not installed. Installing..."
    sudo pacman -S --noconfirm --needed kitty
  fi
  cp ./kitty/kitty.conf ~/.config/kitty/kitty.conf
  cp ./kitty/current-themes.conf ~/.config/kitty/current-themes.conf
}

configure_dotfiles() {
  git clone https://github.com/Rokkit-exe/dotfiles.git /home/frank/
  if [[ ! command -v stow $>/dev/null ]]; then
    echo "Stow is not installed"
    sudo pacman -S --noconfirm --needed stow
  fi

  stow --adopt /home/frank/dotfiles/hypr/
  stow --adopt /home/frank/dotfiles/waybar/
  stow --adopt /home/frank/dotfiles/kitty/
  stow --adopt /home/frank/dotfiles/zshrc/
  stow --adopt /home/frank/dotfiles/nvim/
}


configure_sddm_theme() {
  sddm_config_dir="/etc/sddm.conf.d"
  sddm_config_path="$sddm_config_dir/theme.conf.user"
  sddm_theme_dir="/usr/share/sddm/themes"
  sddm_theme_path="$sddm_theme_dir/simple-sddm-2"
  sddm_background_path="$sddm_theme_path/Backgrounds"
  background_path="/mnt/storage/wallpaper/background.jpg"
  simple_config="$sddm_theme_dir/theme.conf"

  yay -S --noconfirm --needed simple-sddm-theme-2-git

  if [[ -d $sddm_theme_path ]]; then
    sudo mkdir -p $sddm_config_path
    touch sddm_config_path
    sudo echo "[Theme]" >> sddm_config_path
    sudo echo "Current=simple-sddm-2" >> sddm_config_path
    sudo cp $background_path $sddm_background_path
    sed -i "s|^Background=.*$|Background=\"Backgrounds/background.jpg\"" $simple_config
  else
    echo "theme not found"
  fi
}

configure_grub() { 
  theme_path="/mnt/storage/grub_theme/arch/"
  grub_themes_dir="/boot/grub/themes/"
  grub_theme_path=$grub_themes_dir/arch
  grub_config="/etc/default/grub"

  if [[ -d /mnt/storage/grub_theme/arch ]]; then
    sudo cp -r $theme_path $grub_themes_dir
    sudo sed -i "s|^.*GRUB_DISABLE_RECOVERY=.*$|GRUB_DISABLE_RECOVERY=false" $grub_config
    sudo sed -i "s|^.*GRUB_THEME=.*$|GRUB_THEME=$grub_theme_path/theme.txt" $grub_config
    sudo sed -i "s|^.*GRUB_DISABLE_OS_PROBER=.*$|GRUB_DISABLE_OS_PROBER=false" $grub_config
    sudo grub-mkconfig -o /boot/grub/grub.cfg

  else
    echo "Grub theme does not exist in $theme_path"
  fi
}
