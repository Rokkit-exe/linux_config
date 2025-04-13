#!/bin/bash

installing() {
    # Install the package
    echo "------------------------------------------------------------------------"
    echo -e "\nInstalling $1..."
    sleep 1
}

uninstall() {
    # Uninstall the package
    echo "------------------------------------------------------------------------"
    echo -e "\nUninstalling $1..."
    sleep 1
}

flatpak() {
    # Enable Flatpak support in GNOME Software
    echo "------------------------------------------------------------------------"
    apt install flatpak gnome-software-plugin-flatpak -y
    echo "Installaing Flatpak support in GNOME Software..."
    sleep 1
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

discord() {
    # https://discord.com/download
    installing "Discord"

    flatpak install flathub com.discordapp.Discord -y
}

postman() {
    # https://www.postman.com/downloads/
    installing "Postman"

    flatpak install flathub com.getpostman.Postman -y
}

obsidian() {
    # https://obsidian.md/download
    installing "Obsidian"

    flatpak install flathub md.obsidian.Obsidian -y
}

qbittorrent() {
    # https://www.qbittorrent.org/download.php
    installing "qBittorrent"

    flatpak install flathub org.qbittorrent.qBittorrent -y
}

obs() {
    # https://obsproject.com/download
    installing "OBS Studio"

    flatpak install flathub org.obsproject.Studio -y
}

impression() {
    # installing "Impression"
    installing "Impression"
    flatpak install flathub io.gitlab.adhami3310.Impression -y
}

beekeeper() {
    # https://docs.beekeeperstudio.io/installation/linux/#deb
    installing "Beekeeper Studio"

    curl -fsSL https://deb.beekeeperstudio.io/beekeeper.key | gpg --dearmor --output /usr/share/keyrings/beekeeper.gpg \
    && chmod go+r /usr/share/keyrings/beekeeper.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/beekeeper.gpg] https://deb.beekeeperstudio.io stable main" \
    | tee /etc/apt/sources.list.d/beekeeper-studio-app.list > /dev/null

    apt update && apt install beekeeper-studio -y
}


brave() {
    # https://brave.com/linux/
    installing "Brave Browser"

    curl -fsS https://dl.brave.com/install.sh | sh
}

docker() {
    # https://docs.docker.com/engine/install/ubuntu/
    installing "Docker"

    apt update
    apt install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

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
}


go() {
    # go to https://go.dev/dl/ to download the latest
    installing "Go 1.24.2"

    rm -rf /usr/local/go

    wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz

    tar -C /usr/local -xzf ./go1.24.2.linux-amd64.tar.gz

    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

    source ~/.bashrc

    rm ./go1.24.2.linux-amd64.tar.gz

    go version
}


vscode() {
    # https://code.visualstudio.com/download
    installing "Visual Studio Code"

    wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

    apt install ./vscode.deb

    update-alternatives --set editor /usr/bin/code

    rm ./vscode.deb
}

ollama() {
    # https://ollama.com/docs/installation
    installing "Ollama"

    curl -fsSL https://ollama.com/install.sh | sh
}

twingate() {
    # https://docs.twingate.com/docs/linux-install
    installing "Twingate"

    curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash
}

numlock() {
    # Enable NumLock on boot

    apt install numlockx -y
    echo "/usr/bin/numlockx on" >> /etc/gdm3/Init/Default

    sed -i 's/exit 0//g' /etc/gdm3/Init/Default

    echo "exit 0" >> /etc/gdm3/Init/Default
}

python() {
    # Install Python 3.12
    installing "Python 3.12"

    apt install python3.12 python3-pip python3-venv python3-dev python3-full -y

    # Set Python 3.12 as default
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
    update-alternatives --set python3 /usr/bin/python3.12
}

nodejs() {
    # Install Node.js
    installing "Node.js"

    apt install -y nodejs
}

bun() {
    installing "Bun"

    curl -fsSL https://bun.sh/install | bash

    # Add Bun to PATH
    echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
}

java() {
    # Install Java
    installing "Java"

    apt install -y openjdk-20-jdk

    # Set Java 20 as default
    update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-20-openjdk-amd64/bin/java 1
    update-alternatives --set java /usr/lib/jvm/java-20-openjdk-amd64/bin/java
}

kotlin() {
    # Install Kotlin
    installing "Kotlin"

    apt install -y kotlin

    # Set Kotlin as default
    update-alternatives --install /usr/bin/kotlin kotlin /usr/bin/kotlin 1
    update-alternatives --set kotlin /usr/bin/kotlin
}

php() {
    # Install PHP
    installing "PHP"

    apt install -y php8.2 php8.2-cli php8.2-fpm php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip

    # Set PHP 8.2 as default
    update-alternatives --install /usr/bin/php php /usr/bin/php8.2 1
    update-alternatives --set php /usr/bin/php8.2
}

rust() {
    # Install Rust
    installing "Rust"

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # Add Rust to PATH
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
}

uninstall_rust() {
    # Uninstall Rust
    uninstall "Rust"

    rustup self uninstall -y
    rm -rf ~/.cargo
    rm -rf ~/.rustup
    rm -rf ~/.rustup-init.sh
    rm -rf ~/.cargo/bin/rustup
    rm -rf ~/.cargo/bin/rustc
    rm -rf ~/.cargo/bin/cargo
    rm -rf ~/.cargo/bin/rustdoc
    rm -rf ~/.cargo/bin/rustfmt
    rm -rf ~/.cargo/bin/rustup*
}

zen() {
    # Install Zenkit
    installing "Zenkit"

    flatpak install flathub app.zen_browser.zen -y
}

chromium() {
    # Install Chromium
    installing "Chromium"

    flatpak install flathub org.chromium.Chromium -y
}

opera() {
    # Install Opera
    installing "Opera"

    flatpak install flathub com.opera.Opera -y
}

tor() {
    # Install Tor
    installing "Tor"

    flatpak install flathub org.torproject.torbrowser-launcher -y
}






