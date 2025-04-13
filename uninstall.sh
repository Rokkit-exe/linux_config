#!/bin/bash


# uninstall ollama 
echo "------------------------------------------------------------------------"
echo "Uninstalling Ollama...\n"
sleep 1
systemctl stop ollama
systemctl disable ollama
rm /etc/systemd/system/ollama.service
rm $(which ollama)
rm -r /usr/share/ollama
userdel ollama
groupdel ollama
rm -rf /usr/local/lib/ollama

echo "\n Ollama uninstalled successfully."

# uninstall twingate
echo "------------------------------------------------------------------------"
echo "Uninstalling Twingate...\n"
sleep 1
twingate service-stop
apt remove --purge twingate
apt autoremove
rm -rf /etc/twingate
rm -rf /var/lib/twingate
rm -rf /var/run/twingate
rm -rf /var/cache/twingate

echo "\n Twingate uninstalled successfully."


# uninstall Brave
echo "------------------------------------------------------------------------"
echo "Uninstalling Brave...\n"
sleep 1
apt remove brave-browser brave-keyring
rm -rf /etc/apt/sources.list.d/brave-browser-*.list
rm -rf /etc/apt/sources.list.d/brave-browser.list
rm -rf /etc/apt/trusted.gpg.d/brave-browser.gpg
rm -rf /etc/apt/trusted.gpg.d/brave-browser.gpg~
rm -rf /var/lib/apt/lists/brave-browser*
rm -rf /var/lib/apt/lists/brave-browser-archive-keyring.gpg
rm -rf /var/lib/apt/lists/brave-browser-archive-keyring.gpg~
