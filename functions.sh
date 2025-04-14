#!/bin/bash

message_installing() {
    # Display a message
    echo "------------------------------------------------------------------------"
    echo -e "\n\n🛠️  \e[33mInstalling$1 \e[0m"
    sleep 1
}

message_update() {
    # Display an update message
    echo "------------------------------------------------------------------------"
    echo -e "\n\n🔄 \e[36mUpdating$1 \e[0m"
    sleep 1
}

message_uninstalling() {
    # Display a message
    echo "------------------------------------------------------------------------"
    echo -e "\n\n🗑️  \e[31mUninstalling$1 \e[0m"
    sleep 1
}

message_done() {
    # Display a done message
    echo "------------------------------------------------------------------------"
    echo -e "\n\n✅ \e[32m$1\e[0m"
    sleep 1
}

message_error() {
    # Display an error message
    echo "------------------------------------------------------------------------"
    echo -e "\n\n❌ \e[31mError: $1 \e[0m"
}

message_configure() {
    # Display a configuration message
    echo "------------------------------------------------------------------------"
    echo -e "\n\n⚙️ \e[36mConfiguring: $1 \e[0m"
}

message_warning() {
    # Display a warning message
    echo "------------------------------------------------------------------------"
    echo -e "\n\n⚠️ \e[33mWarning: $1 \e[0m"
}

message_info() {
    # Display an info message
    echo "------------------------------------------------------------------------"
    echo -e "\n\nℹ️ \e[34mInformation: $1 \e[0m"
}

welcome() {
    cat ./mycli_ascii.txt
    echo 
    echo "------------------------------------------------------------------------"
    echo "Welcome to the Package Installer Script!"
}

check_sudo() {
    # Check if the script is run as root
    if [ "$EUID" -ne 0 ]; then
        message_error "Please run as root"
        exit 1
    fi
}

check_debian() {
    # Check if the system is Debian-based
    if grep -qi "debian" /etc/os-release; then
        echo "Debian-based system"
    else
        message_error "This script is designed for Debian-based systems."
        exit 1
    fi
}

check_zenity() {
    # Check if Zenity is installed
    if ! command -v zenity &> /dev/null; then
        message_installing "Zenity"
        apt install -y zenity
    fi
}