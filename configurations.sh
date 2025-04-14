#!/bin/bash

source ./functions.sh

configure_flatpak() {
    # Enable Flatpak support in GNOME Software
    message_configure "Flatpak"
    if ! command -v flatpak &> /dev/null; then
        echo "Flatpak is not installed. Installing..."
        apt install flatpak -y
    else
        echo "Flatpak is already installed."
    fi

    if echo "$DESKTOP_SESSION" | grep -q "gnome"; then
        echo "Enabling Flatpak support in GNOME Software..."
        apt install flatpak gnome-software-plugin-flatpak -y
    elif echo "$DESKTOP_SESSION" | grep -q "cinnamon"; then
        echo "Installing Flatpak for Cinnamon..."
        apt install flatpak -y
        return
    fi
    echo "Adding Flathub repository..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    message_done "Flatpak configured successfully!"
}

configure_oh_my_posh() {
    message_installing "Oh My Posh"

    # Check if already installed
    if command -v oh-my-posh &> /dev/null; then
        echo "✅ Oh My Posh is already installed."
        return
    fi

    # Ensure PATH is updated for installation
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        echo 'export PATH="$PATH:$HOME/.local/bin"' >> ~/.bashrc
        export PATH="$PATH:$HOME/.local/bin"
    fi

    # Create themes folder
    mkdir -p "$HOME/.poshthemes"

    # Install oh-my-posh
    curl -s https://ohmyposh.dev/install.sh | bash -s

    # Download theme
    curl -o "$HOME/.poshthemes/craver.omp.json" https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/craver.omp.json

    # Add init line to .bashrc if not already present
    if ! grep -q "oh-my-posh init bash --config .*craver.omp.json" ~/.bashrc; then
        echo 'eval "$(oh-my-posh init bash --config $HOME/.poshthemes/craver.omp.json)"' >> ~/.bashrc
    fi

    message_done "Oh My Posh installed successfully!"
    message_info "Please restart your terminal or run 'source ~/.bashrc' to apply changes"
}


configure_numlock() {
    # Enable NumLock on boot
    apt install numlockx -y

    echo "[Seat:*]" >> /etc/lightdm/lightdm.conf.d/50-myconfig.conf
    echo "greeter-setup-script=/usr/bin/numlockx on" >> /etc/lightdm/lightdm.conf.d/50-myconfig.conf
    message_done "NumLock enabled on boot!"
    message_info "Please restart your computer to apply changes"
}

configure_logid() {
    message_installing "logiops"

    apt install logiops -y

    cp -f ./logid.cfg /etc/logid.cfg
    systemctl restart logid
    message_done "logiops installed successfully!"
    message_info "Please restart your computer to apply changes"
}