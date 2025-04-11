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

# Updating before Installing
echo "------------------------------------------------------------------------"
echo "Updating package list..."
sleep 1

apt update && apt full-upgrade -y

# Installing APT packages
echo "------------------------------------------------------------------------"
echo "Installing APT packages..."
sleep 1
apt install -y \
    build-essential \
    bluetooth \
    cmake \
    pkg-config \
    libevdev-dev \
    lubudev-dev \
    libconfig++-dev \
    libglib2.0-dev \
    ca-certificates \
    os-prober \
    wget \
    curl \
    vim \
    neofetch \
    python3.12 \
    python3.12-pip \
    python3.12-venv \
    python3.12-dev \
    python3.12-full \
    python3.12-xyz \
    pipx \
    git \
    qemu-system \
    qemu-user-static \
    virt-manager \
    solaar \
    numlockx \
    dconf-editor \
    gnome-tweaks \
    gnome-shell-extensions \
    gnome-shell-extension-manager \
    gnome-shell-extension-prefs \
    dotnet-sdk-8.0 \
    vlc \
    mariadb-server \
    powertop \
    flatpak \
    gnome-software-plugin-flatpak \
    lm-sensors \
    nethogs \
    iotop \
    gtop \
    htop \
    nvidia-utils-570-server

pipx install gnome-extensions-cli

echo "✅ apt packages installation complete!"
sleep 1


# Enable Flatpak support in GNOME Software
echo "------------------------------------------------------------------------"
echo "Adding Flathub repo..."
sleep 1
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


# Install Flatpak packages
echo "------------------------------------------------------------------------"
echo "Installing Flatpak packages..."
sleep 1

flatpak install flathub \
    com.discordapp.Discord \
    com.getpostman.Postman \
    io.gitlab.adhami3310.Impression \
    com.jeffser.Alpaca \
    com.mattjakeman.ExtensionManager \
    md.obsidian.Obsidian \
    com.obsproject.Studio \
    com.valvesoftware.Steam \
    org.qbittorrent.qBittorrent \


# https://docs.beekeeperstudio.io/installation/linux/#deb
echo "------------------------------------------------------------------------"
echo "Installing Beekeeper Studio..."
sleep 1

curl -fsSL https://deb.beekeeperstudio.io/beekeeper.key | gpg --dearmor --output /usr/share/keyrings/beekeeper.gpg \
  && chmod go+r /usr/share/keyrings/beekeeper.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/beekeeper.gpg] https://deb.beekeeperstudio.io stable main" \
  | tee /etc/apt/sources.list.d/beekeeper-studio-app.list > /dev/null

apt update && apt install beekeeper-studio -y


# visit https://brave.com/linux/
echo "------------------------------------------------------------------------"
echo "Installing Brave..."
sleep 1

curl -fsS https://dl.brave.com/install.sh | sh


# visit https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
echo "------------------------------------------------------------------------"
echo "Installing Docker..."
sleep 1

apt update
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update

apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# go to https://go.dev/dl/ to download the latest
echo "------------------------------------------------------------------------"
echo "Installing Go..."
sleep 1

rm -rf /usr/local/go

wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz

tar -C /usr/local -xzf ./go1.24.2.linux-amd64.tar.gz

echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

source ~/.bashrc

rm ./go1.24.2.linux-amd64.tar.gz

go version


# https://code.visualstudio.com/download
echo "------------------------------------------------------------------------"
echo "Installing Visual Studio Code..."
sleep 1

wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

apt install ./vscode.deb

update-alternatives --set editor /usr/bin/code

rm ./vscode.deb


# https://ollama.com/docs/installation
echo "------------------------------------------------------------------------"
echo "Installing Ollama..."
sleep 1

curl -fsSL https://ollama.com/install.sh | sh


# https://docs.twingate.com/docs/linux-install
echo "------------------------------------------------------------------------"
echo "Installing Twingate..."
sleep 1

curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash

# https://store.steampowered.com/about/
echo "------------------------------------------------------------------------"
echo "Installing Steam..."
sleep 1
wget -O steam.deb "https://cdn.fastly.steamstatic.com/client/installer/steam.deb"
apt install ./steam.deb
rm ./steam.deb


# Enabling numlock on startup
echo "------------------------------------------------------------------------"
echo "Enabling numlock on startup..."
sleep 1
echo "/usr/bin/numlockx on" >> /etc/gdm3/Init/Default

sed -i 's/exit 0//g' /etc/gdm3/Init/Default

echo "exit 0" >> /etc/gdm3/Init/Default


# adding drive to quick access and mounting it
echo "------------------------------------------------------------------------"
echo "Adding drive to quick access..."
sleep 1
echo "file:///media/frank/storage" >> ~/.config/gtk-3.0/bookmarks
echo "file:///media/frank/9CEE4E33EE4E064C windows" >> ~/.config/gtk-3.0/bookmarks
sudo mkdir -p /media/frank/storage
sudo mkdir -p /media/frank/9CEE4E33EE4E064C
echo "sudo mount -t ntfs-3g /dev/sda1 /media/frank/storage" >> ~/.bashrc
echo "sudo mount -t ntfs-3g /dev/sdb1 /media/frank/9CEE4E33EE4E064C" >> ~/.bashrc
source ~/.bashrc

# adding gnome extensions
echo "------------------------------------------------------------------------"
echo "Adding gnome extensions..."
sleep 1

gnome-extensions-cli install \
    appmenu-is-back@fthx \
    clipboard-indicator@tudmotu.com \
    dash-to-dock@micxgx.gmail.com \
    gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com \
    logomenu@aryan_k \
    quick-settings-tweaks@qwreey \
    system-monitor-indicator@mknap.com \
    twingate-status@eudes.es



# setting dark theme
echo "------------------------------------------------------------------------"
echo "Setting dark theme..."
sleep 1
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    
# setting background
echo "------------------------------------------------------------------------"
echo "Setting background..."
sleep 1
mkdir -p /home/frank/Pictures/wallpaper
cp ./spike.jpg /home/frank/Pictures/wallpaper/spike.jpg
gsettings set org.gnome.desktop.background picture-uri "file:///home/frank/Pictures/wallpaper/spike.jpg"


# logiops driver install
echo "------------------------------------------------------------------------"
echo "Installing logiops driver..."
sleep 1
git clone https://github.com/PixlOne/logiops.git
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make

sudo make install
sudo systemctl enable --now logid

# creating environment variables for ollama
echo "------------------------------------------------------------------------"
echo "Creating environment variables for ollama..."
sleep 1
#echo "export OLLAMA_MODELS=/media/frank/storage/llms/ollama" >> ~/.bashrc
echo "OLLAMA_ORIGINS:[http://localhost https://localhost http://localhost:* https://localhost:* http://127.0.0.1 https://127.0.0.1 http://127.0.0.1:* https://127.0.0.1:* http://0.0.0.0 https://0.0.0.0 http://0.0.0.0:* https://0.0.0.0:* app://* file://* tauri://* vscode-webview://* vscode-file://* http://192.168.0.*:*]" >> ~/.bashrc
echo "export OLLAMA_HOST=192.168.0.20:11434" >> ~/.bashrc
source ~/.bashrc

# discover bluetooth dongle
echo "------------------------------------------------------------------------"
echo "Discovering bluetooth dongle..."
sleep 1
echo "sudo modprobe btusb" >> ~/.bashrc
echo "sudo systemctl restart bluetooth.service" >> ~/.bashrc
source ~/.bashrc
