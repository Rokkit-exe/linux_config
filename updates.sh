#!/bin/bash

source ./functions.sh

update_apt() {
    # Update APT
    message_update "APT"
    apt update && apt full-upgrade -y
    apt autoremove -y
    message_done "APT updated successfully!"
}

update_flatpak() {
    # Update Flatpak
    message_update "Flatpak"
    flatpak update -y && flatpak uninstall --unused -y
    message_done "Flatpak updated successfully!"
}

autoremove() {
    # Autoremove unused packages
    message_update "APT and Flatpak"
    apt autoremove -y
    flatpak uninstall --unused -y
    message_done "Unused packages removed successfully!"
}