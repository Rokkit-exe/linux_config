#!/bin/bash

source ./functions.sh

install_beekeeper-studio() {
    # https://docs.beekeeperstudio.io/installation/linux/#deb
    message_installing "Beekeeper Studio"

    curl -fsSL https://deb.beekeeperstudio.io/beekeeper.key | gpg --dearmor --output /usr/share/keyrings/beekeeper.gpg \
    && chmod go+r /usr/share/keyrings/beekeeper.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/beekeeper.gpg] https://deb.beekeeperstudio.io stable main" \
    | tee /etc/apt/sources.list.d/beekeeper-studio-app.list > /dev/null

    apt update && apt install beekeeper-studio -y

    message_done "Beekeeper Studio installed successfully!"
}


install_brave() {
    # https://brave.com/linux/
    message_installing "Brave Browser"

    curl -fsS https://dl.brave.com/install.sh | sh

    message_done "Brave Browser installed successfully!"
}

install_docker() {
    # https://docs.docker.com/engine/install/ubuntu/
    message_installing "Docker"

    apt update -y
    apt install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    apt update -y
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt update -y

    apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    message_done "Docker installed successfully!"
}


install_golang() {
    # go to https://go.dev/dl/ to download the latest
    message_installing "Go 1.24.2"

    [ -d /usr/local/go ] && rm -rf /usr/local/go || echo "Go not installed"

    sed -i '/^export PATH=\$PATH:\/usr\/local\/go\/bin$/d' ~/.bashrc

    wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz

    tar -C /usr/local -xzf ./go1.24.2.linux-amd64.tar.gz

    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc

    source ~/.bashrc

    rm ./go1.24.2.linux-amd64.tar.gz

    message_done "Go installed successfully!"
}


install_vscode() {
    # https://code.visualstudio.com/download
    message_installing "Visual Studio Code"

    wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

    apt install ./vscode.deb

    update-alternatives --set editor /usr/bin/code

    rm ./vscode.deb

    message_done "Visual Studio Code installed successfully!"
}

install_intellij-idea() {
    message_installing "intellij-idea-community"
    local url="https://download.jetbrains.com/idea/ideaIC-2024.1.tar.gz"
    local tmp_dir="/tmp/intellij"
    local install_dir="/opt/intellij"
    local desktop_file="/usr/share/applications/intellij-idea-community.desktop"

    echo "📥 Downloading IntelliJ IDEA Community Edition..."
    mkdir -p "$tmp_dir"
    wget -O "$tmp_dir/idea.tar.gz" "$url"

    echo "📦 Extracting IntelliJ..."
    sudo mkdir -p "$install_dir"
    sudo tar -xzf "$tmp_dir/idea.tar.gz" --strip-components=1 -C "$install_dir"

    echo "⚙️ Creating symlink..."
    sudo ln -sf "$install_dir/bin/idea.sh" /usr/local/bin/intellij

    echo "🖥️ Creating desktop entry..."
    cat <<EOF | sudo tee "$desktop_file" > /dev/null
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA Community
Icon=$install_dir/bin/idea.png
Exec="$install_dir/bin/idea.sh" %f
Comment=IntelliJ IDEA Community Edition
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-idea
EOF

    message_done "IntelliJ IDEA Community installed successfully!"
}

install_pycharm() {
    message_installing "PyCharm Community"
    local url="https://download.jetbrains.com/python/pycharm-community-2024.1.tar.gz"
    local tmp_dir="/tmp/pycharm"
    local install_dir="/opt/pycharm"
    local desktop_file="/usr/share/applications/pycharm-community.desktop"

    echo "📥 Downloading PyCharm Community Edition..."
    mkdir -p "$tmp_dir"
    wget -O "$tmp_dir/pycharm.tar.gz" "$url"

    echo "📦 Extracting PyCharm..."
    sudo mkdir -p "$install_dir"
    sudo tar -xzf "$tmp_dir/pycharm.tar.gz" --strip-components=1 -C "$install_dir"

    echo "⚙️ Creating symlink..."
    sudo ln -sf "$install_dir/bin/pycharm.sh" /usr/local/bin/pycharm

    echo "🖥️ Creating desktop entry..."
    cat <<EOF | sudo tee "$desktop_file" > /dev/null
[Desktop Entry]
Version=1.0
Type=Application
Name=PyCharm Community
Icon=$install_dir/bin/pycharm.png
Exec="$install_dir/bin/pycharm.sh" %f
Comment=PyCharm Community Edition
Categories=Development;IDE;Python;
Terminal=false
StartupWMClass=jetbrains-pycharm
EOF

    message_done "PyCharm Community installed successfully!"
}


install_ollama() {
    # https://ollama.com/docs/installation
    message_installing "Ollama"

    curl -fsSL https://ollama.com/install.sh | sh

    message_done "Ollama installed successfully!"
}

install_twingate() {
    # https://docs.twingate.com/docs/linux-install
    message_installing "Twingate"

    curl -s https://binaries.twingate.com/client/linux/install.sh | sudo bash

    message_done "Twingate installed successfully!"
}

install_cider() {
    message_installing "Cider"
    apt install ./cider-linux-debian_X64.deb -y

    message_done "Cider installed successfully!"
}

install_steam() {
    message_installing "Steam"
    curl https://cdn.fastly.steamstatic.com/client/installer/steam.deb -o steam.deb
    apt install ./steam.deb -y
    rm ./steam.deb
    echo "Steam installed successfully!"

    message_done "Steam installed successfully!"
}



install_python() {
    # Install Python 3.12
    message_installing "Python 3.12"

    apt install python3.12 python3-pip python3-venv python3-dev python3-full -y

    # Set Python 3.12 as default
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
    update-alternatives --set python3 /usr/bin/python3.12

    message_done "Python 3.12 installed successfully!"
}

install_nodejs() {
    # Install Node.js
    message_installing "Node.js"

    apt install -y nodejs

    message_done "Node.js installed successfully!"
}

install_bun() {
    message_installing "Bun"

    curl -fsSL https://bun.sh/install | bash

    # Add Bun to PATH
    echo 'export PATH="$HOME/.bun/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc

    message_done "Bun installed successfully!"
}

install_java() {
    # Install Java
    message_installing "Java"

    apt install -y openjdk-20-jdk

    # Set Java 20 as default
    update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-20-openjdk-amd64/bin/java 1
    update-alternatives --set java /usr/lib/jvm/java-20-openjdk-amd64/bin/java

    message_done "Java installed successfully!"
}

install_kotlin() {
    # Install Kotlin
    message_installing "Kotlin"

    apt install -y kotlin

    # Set Kotlin as default
    update-alternatives --install /usr/bin/kotlin kotlin /usr/bin/kotlin 1
    update-alternatives --set kotlin /usr/bin/kotlin

    message_done "Kotlin installed successfully!"
}

install_php() {
    # Install PHP
    message_installing "PHP"

    apt install -y php8.2 php8.2-cli php8.2-fpm php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip

    # Set PHP 8.2 as default
    update-alternatives --install /usr/bin/php php /usr/bin/php8.2 1
    update-alternatives --set php /usr/bin/php8.2

    message_done "PHP installed successfully!"
}

install_rust() {
    # Install Rust
    message_installing "Rust"

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

    # Add Rust to PATH
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc

    message_done "Rust installed successfully!"
}









