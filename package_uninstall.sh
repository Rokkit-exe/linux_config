#!/bin/bash

source ./functions.sh

uninstall_ollama() {
    # Uninstall Ollama
    echo "🗑️ Uninstalling Ollama..."

    # check if ollama is installed
    if ! command -v ollama &> /dev/null; then
        echo "Ollama is not installed."
        return
    fi
    # stop and disable the service
    systemctl stop ollama
    systemctl disable ollama

    # remove the service
    systemctl disable --now ollama
    systemctl daemon-reload

    # remove the ollama binary
    rm -f /etc/systemd/system/ollama.service
    rm -f $(which ollama)
    rm -rf /usr/share/ollama
    userdel ollama
    groupdel ollama
    rm -rf /usr/local/lib/ollama

    message_done "Ollama uninstalled successfully."
}

uninstall_twingate() {
    # Uninstall Twingate
    message_uninstalling "Twingate"

    # check if twingate is installed
    if ! command -v twingate &> /dev/null; then
        echo "Twingate is not installed."
        return
    fi

    # stop and disable the service
    systemctl stop twingate
    systemctl disable twingate

    # remove the service
    systemctl disable --now twingate
    systemctl daemon-reload

    # remove the twingate binary
    rm -f /etc/systemd/system/twingate.service
    rm -f $(which twingate)
    rm -rf /usr/share/twingate
    userdel twingate
    groupdel twingate
    rm -rf /usr/local/lib/twingate
    rm -rf /var/lib/twingate

    message_done "Twingate uninstalled successfully."
}

uninstall_brave() {
    # uninstall Brave
    echo "🗑️ Uninstalling Brave Browser..."
    # check if brave is installed
    if ! command -v brave &> /dev/null; then
        echo "Brave Browser is not installed."
        return
    fi

    # remove the brave browser
    apt remove --purge -y brave-browser
    rm -rf /etc/apt/sources.list.d/brave-browser.list
    rm -rf /etc/apt/trusted.gpg.d/brave-browser.gpg
    rm -rf /etc/apt/trusted.gpg.d/brave-browser.gpg
    rm -rf /usr/share/keyrings/brave-browser.gpg
    rm -rf /usr/share/applications/brave-browser.desktop
    rm -rf /usr/share/icons/hicolor/*/apps/brave-browser.png
}


uninstall_intellij() {
    message_uninstalling "IntelliJ IDEA Community"

    # check if intellij is installed
    if ! command -v intellij &> /dev/null; then
        echo "IntelliJ IDEA is not installed."
        return
    fi
    # Remove IntelliJ IDEA installation
    rm -rf /opt/intellij-idea-community

    # Remove installation directory
    rm -rf /opt/intellij

    # Remove symlink
    rm -f /usr/local/bin/intellij

    # Remove desktop entry
    rm -f /usr/share/applications/intellij-idea-community.desktop

    # Remove JetBrains config and system files
    rm -rf ~/.config/JetBrains/IdeaIC2024.3
    rm -rf ~/.local/share/JetBrains/IdeaIC2024.3

    message_done "IntelliJ IDEA Community uninstalled successfully!"
}

uninstall_pycharm() {
    message_uninstalling "PyCharm Community"

    # check if pycharm is installed
    if ! command -v pycharm &> /dev/null; then
        echo "PyCharm is not installed."
        return
    fi

    # Remove installation directory
    rm -rf /opt/pycharm

    # Remove symlink
    rm -f /usr/local/bin/pycharm

    # Remove desktop entry
    rm -f /usr/share/applications/pycharm-community.desktop

    # Remove JetBrains config and system files
    rm -rf ~/.config/JetBrains/PyCharmCE2024.3
    rm -rf ~/.local/share/JetBrains/PyCharmCE2024.3

    message_done "PyCharm Community uninstalled successfully!"
}


uninstall_rust() {
    # Uninstall Rust
    message_uninstalling "Rust"

    # Check if rustup is installed
    if ! command -v rustup &> /dev/null; then
        echo "Rust is not installed."
        return
    fi

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

    message_done "Rust uninstalled successfully!"
}


