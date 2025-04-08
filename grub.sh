#!/bin/bash
sudo apt update
sudo apt install os-prober

sudo nano /etc/default/grub


# make sure these line are present
GRUB_TIMEOUT=10         # Wait 10 seconds at boot (or any value > 0)
GRUB_TIMEOUT_STYLE=menu # Force showing the menu
GRUB_HIDDEN_TIMEOUT=0   # Optional: make sure this line is removed or commented out

# uncomment this line
GRUB_DISABLE_OS_PROBER=false


sudo update-grub

sudo reboot