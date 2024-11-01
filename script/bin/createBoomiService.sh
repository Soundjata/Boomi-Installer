#!/bin/bash

# Source the exports file to get variable definitions
#source ./exports.sh

# Construct the service file path
service_file="/etc/systemd/system/boomi-${atomName}.service"

# Change ownership of the installation directory
chown -R "$service_user":"$service_group" "$INSTALL_DIR"

# Construct the service content
service_content="[Unit]
Description= Boomi ${atomName}
After=network.target

[Service]
Type=forking
User=${service_user}
Restart=always
ExecStart=${INSTALL_DIR}/${atomType}_${atomName}/bin/atom start
ExecStop=${INSTALL_DIR}/${atomType}_${atomName}/bin/atom stop
ExecReload=${INSTALL_DIR}/${atomType}_${atomName}/bin/atom restart

[Install]
WantedBy=multi-user.target
"

# Write the content to the service file
echo "$service_content" | sudo tee "$service_file" > /dev/null

# Reload systemd to recognize the new service
systemctl daemon-reload

# Enable the service to start on boot
systemctl enable boomi-${atomName}.service

echo "Boomi service created and enabled as 'boomi-${atomName}.service'."
