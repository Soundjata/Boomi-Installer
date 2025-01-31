#!/bin/bash

sudo apt-get -qq --yes update
sudo apt-get -qq --yes install git unzip zip jq

ID=$(id -u)

if [ -d "/etc/Boomi-Installer" ]; then sudo rm -R /etc/Boomi-Installer; fi
sudo mkdir /etc/Boomi-Installer
sudo git clone https://github.com/Soundjata/Boomi-Installer.git /etc/Boomi-Installer
sudo chmod +x /etc/Boomi-Installer/script/menu.sh
sudo chown $ID:$ID -R /etc/Boomi-Installer

sudo apt-get -qq --yes remove git
sudo apt-get -qq --yes purge git

#Increase network buffers:
sudo sysctl -w net.core.rmem_max=8388608
sudo sysctl -w net.core.wmem_max=8388608
sudo sysctl -w net.core.rmem_default=65536
sudo sysctl -w net.core.wmem_default=65536

# Use a lock file to prevent race conditions
LOCKFILE="/tmp/limits.conf.lock"

if ( set -o noclobber; echo "$$" > "$LOCKFILE" ) 2> /dev/null; then

  # Check and set soft limit
  if ! grep -qE "^\s*${ID}\s+soft\s+nofile\s+65536\s*$" /etc/security/limits.conf; then
    echo "${ID} soft nofile 65536" | sudo tee -a /etc/security/limits.conf > /dev/null
  fi

  # Check and set hard limit
  if ! grep -qE "^\s*${ID}\s+hard\s+nofile\s+65536\s*$" /etc/security/limits.conf; then  # Corrected hard limit value
    echo "${ID} hard nofile 65536" | sudo tee -a /etc/security/limits.conf > /dev/null   # Corrected hard limit value
  fi

  rm -f "$LOCKFILE"  # Remove the lock file
else
  echo "Warning: Could not acquire lock. Another process might be modifying limits.conf."
fi


