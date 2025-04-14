#!/bin/bash

source ./functions.sh
source ./packages.sh
source ./package_install.sh
source ./package_uninstall.sh
source ./configurations.sh
source ./updates.sh

main_menu() {
    choice=$(zenity --list \
    --radiolist \
    --title="Main Menu" \
    --width=800 --height=500 \
    --column="Select" --column="Action" \
    TRUE  "Install Packages" \
    FALSE "Uninstall Packages" \
    FALSE "Update system" \
    FALSE "Configuration" \
    FALSE "Quit")

    if [[ $? -eq 0 ]]; then
        echo "You selected: $choice"
        case "$choice" in
            "Install Packages")
                apt update -y
                configure_flatpak
                install_menu
                ;;
            "Uninstall Packages")
                uninstall_menu
                autoremove
                ;;
            "Update system")
                update_apt
                update_flatpak
                autoremove
                ;;
            "Configuration")
                configure_menu
                ;;
            "Quit")
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid selection."
                ;;
        esac
    else
        echo "Menu canceled."
    fi
}

install_menu() {
    choice=$(zenity --list \
    --radiolist \
    --title="Install Menu" \
    --width=800 --height=500 \
    --column="Select" --column="Action" \
    TRUE  "All Package Categories" \
    FALSE "Essentials" \
    FALSE "Utilities" \
    FALSE "Development" \
    FALSE "Main Menu" \
    FALSE "Quit")

    if [[ $? -eq 0 ]]; then
        echo "You selected: $choice"
        case "$choice" in
            "All Package Categories")
                menu_install_package_category "Essentials" "ESSENTIALS"
                menu_install_package_category "Utilities" "UTILITIES"
                menu_install_package_category "Development" "DEVELOPMENT"
                ;;
            "Essentials")
                menu_install_package_category "Essentials" "ESSENTIALS"
                ;;
            "Utilities")
                menu_install_package_category "Essentials" "ESSENTIALS"
                ;;
            "Development")
                menu_install_package_category "Development" "DEVELOPMENT"
                ;;
            "Main Menu")
                main_menu
                ;;
            "Quit")
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid selection."
                ;;
        esac
    else
        echo "Menu canceled."
    fi
}


configure_menu() {
    # Build zenity arguments
    ZENITY_ARGS=()
    for ((i=0; i<${#CONFIGURATIONS[@]}; i+=4)); do
        display_name="${CONFIGURATIONS[i]}"
        method="${CONFIGURATIONS[i+1]}"
        pkg="${CONFIGURATIONS[i+2]}"
        checked="${CONFIGURATIONS[i+3]}"

        # Convert to zenity-compatible TRUE/FALSE
        [[ "$checked" == "ON" ]] && checked="TRUE" || checked="FALSE"

        ZENITY_ARGS+=( "$checked" "$display_name" "$method" "$pkg" )
    done

    SELECTED=$(zenity --list \
    --title="Select Your Configurations" \
    --width=800 --height=500 \
    --checklist \
    --column="Configure" --column="Description" --column="Method" --column="Package" \
    "${ZENITY_ARGS[@]}"
    )

    if [[ $? -eq 0 ]]; then
        echo "Selected packages (method package_name):"
        IFS="|" read -ra CHOICES <<< "$SELECTED"
        for selected_display_name in "${CHOICES[@]}"; do
            for ((i=0; i<${#packages[@]}; i+=4)); do
                display_name="${packages[i]}"
                pkg="${packages[i+2]}"
                if [[ "$display_name" == "$selected_display_name" ]]; then
                    if declare -f "$pkg" > /dev/null; then
                        message_installing "$pkg using official installer..."
                        eval "install_$pkg"
                    else
                        echo "Function $pkg not found!"
                    fi
                fi
            done
        done
    else
        echo "Cancelled or no selection."
    fi
}

menu_install_package_category() {
    local title="$1"
    local array_name="$2"
    declare -n packages="$array_name"  # Create a nameref to the array

    # Build zenity arguments
    ZENITY_ARGS=()
    for ((i=0; i<${#packages[@]}; i+=4)); do
        display_name="${packages[i]}"
        method="${packages[i+1]}"
        pkg="${packages[i+2]}"
        checked="${packages[i+3]}"

        # Convert to zenity-compatible TRUE/FALSE
        [[ "$checked" == "ON" ]] && checked="TRUE" || checked="FALSE"

        ZENITY_ARGS+=( "$checked" "$display_name" "$method" "$pkg" )
    done

    # Show zenity dialog
    SELECTED=$(zenity --list \
    --title="Select $title Packages" \
    --width=800 --height=500 \
    --checklist \
    --column="Install" --column="Display Name" --column="Method" --column="Package" \
    "${ZENITY_ARGS[@]}"
    )

    if [[ $? -eq 0 ]]; then
        echo "Selected packages (method package_name):"
        IFS="|" read -ra CHOICES <<< "$SELECTED"
        for selected_display_name in "${CHOICES[@]}"; do
            for ((i=0; i<${#packages[@]}; i+=4)); do
                display_name="${packages[i]}"
                method="${packages[i+1]}"
                pkg="${packages[i+2]}"
                if [[ "$display_name" == "$selected_display_name" ]]; then
                    # Install based on the method
                    case "$method" in
                        func)
                            if declare -f "$pkg" > /dev/null; then
                                message_installing "$pkg using official installer..."
                                eval "install_$pkg"
                            else
                                echo "Function $pkg not found!"
                            fi
                            ;;
                        apt)
                            message_installing "$display_name using apt..."
                            apt install -y "$pkg"
                            ;;
                        flatpak)
                            message_installing "$display_name using flatpak..."
                            flatpak install flathub -y "$pkg"
                            ;;
                        *)
                            echo "Unknown installation method for $display_name"
                            ;;
                    esac
                fi
            done
        done
    else
        echo "Cancelled or no selection."
    fi
}

uninstall_menu() {
    choice=$(zenity --list \
    --radiolist \
    --title="Uninstall Menu" \
    --width=800 --height=500 \
    --column="Select" --column="Action" \
    TRUE  "All Package Categories" \
    FALSE "Essentials" \
    FALSE "Utilities" \
    FALSE "Development" \
    FALSE "Main Menu" \
    FALSE "Quit")

    if [[ $? -eq 0 ]]; then
        echo "You selected: $choice"
        case "$choice" in
            "All Package Categories")
                menu_uninstall_package_category "Essentials" "ESSENTIALS"
                menu_uninstall_package_category "Utilities" "UTILITIES"
                menu_uninstall_package_category "Development" "DEVELOPMENT"
                ;;
            "Essentials")
                menu_uninstall_package_category "Essentials" "ESSENTIALS"
                ;;
            "Utilities")
                menu_uninstall_package_category "Utilities" "UTILITIES"
                ;;
            "Development")
                menu_uninstall_package_category "Development" "DEVELOPMENT"
                ;;
            "Main Menu")
                main_menu
                ;;
            "Quit")
                echo "Exiting..."
                exit 0
                ;;
            *)
                echo "Invalid selection."
                ;;
        esac
    else
        echo "Menu canceled."
    fi
}

menu_uninstall_package_category() {
    local title="$1"
    local array_name="$2"
    declare -n packages="$array_name"  # Create a nameref to the array

    # Build zenity arguments
    ZENITY_ARGS=()
    for ((i=0; i<${#packages[@]}; i+=4)); do
        display_name="${packages[i]}"
        method="${packages[i+1]}"
        pkg="${packages[i+2]}"
        checked="${packages[i+3]}"

        # Convert to zenity-compatible TRUE/FALSE
        #[[ "$checked" == "ON" ]] && checked="TRUE" || checked="FALSE"

        ZENITY_ARGS+=( "$checked" "$display_name" "$method" "$pkg" )
    done

    # Show zenity dialog
    SELECTED=$(zenity --list \
    --title="Select $title Packages" \
    --width=800 --height=500 \
    --checklist \
    --column="Install" --column="Display Name" --column="Method" --column="Package" \
    "${ZENITY_ARGS[@]}"
    )

    if [[ $? -eq 0 ]]; then
        echo "Selected packages (method package_name):"
        IFS="|" read -ra CHOICES <<< "$SELECTED"
        for selected_display_name in "${CHOICES[@]}"; do
            for ((i=0; i<${#packages[@]}; i+=4)); do
                display_name="${packages[i]}"
                method="${packages[i+1]}"
                pkg="${packages[i+2]}"
                if [[ "$display_name" == "$selected_display_name" ]]; then
                    # Install based on the method
                    case "$method" in
                        func)
                            if declare -f "$pkg" > /dev/null; then
                                message_uninstalling "$pkg using official installer..."
                                eval "uninstall_$pkg"
                            else
                                echo "Function $pkg not found!"
                            fi
                            ;;
                        apt)
                            message_uninstalling "$display_name using apt..."
                            apt purge -y "$pkg"
                            ;;
                        flatpak)
                            message_uninstalling "$display_name using flatpak..."
                            flatpak uninstall flathub -y "$pkg"
                            ;;
                        *)
                            echo "Unknown installation method for $display_name"
                            ;;
                    esac
                fi
            done
        done
    else
        echo "Cancelled or no selection."
    fi
}