#!/bin/bash

source ./functions.sh

# Exit on error
set -e

welcome

check_sudo
check_debian
check_zenity

source ./menus.sh

while true; do
    main_menu
done

