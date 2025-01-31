#!/bin/bash

sudo apt-get -qq --yes update
sudo apt-get -qq --yes install git unzip zip sudo jq

ID=$(id -u)

if [ -d "/etc/Boomi-Installer" ]; then sudo rm -R /etc/Boomi-Installer; fi
sudo mkdir /etc/Boomi-Installer
sudo git clone https://github.com/Soundjata/Boomi-Installer.git /etc/Boomi-Installer
sudo chmod +x /etc/Boomi-Installer/script/menu.sh
sudo chown $ID:$ID -R /etc/Boomi-Installer

sudo apt-get remove git
sudo apt-get purge git
