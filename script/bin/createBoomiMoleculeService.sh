#!/bin/bash

# Source the exports file to get variable definitions
#source ./exports.sh

# Construct the service file path
service_file="/etc/systemd/system/boomi-${atomName}.service"

# Change ownership of the installation directory
chown -R "$service_user":"$service_group" "$INSTALL_DIR"

# Construct the service content
service_content="[Unit]
Description=Boomi Atom
SourcePath=/${INSTALL_DIR}/Molecule_${atomName}
After=network.target
[Service]
LimitNOFILE=65536
LimitNPROC=65536
Environment=\"INSTALL4J_JAVA_HOME_OVERRIDE=/${INSTALL_DIR}/Molecule_${atomName}/jre\"
Type=forking
Restart=always
TimeoutSec=5min
IgnoreSIGPIPE=no
KillMode=process
GuessMainPID=yes
RemainAfterExit=yes
User=${service_user}
Group=${service_group}
ExecStart=/${INSTALL_DIR}/Molecule_${atomName}/bin/atom start
ExecStop=/${INSTALL_DIR}/Molecule_${atomName}/bin/atom stop
ExecReload=/${INSTALL_DIR}/Molecule_${atomName}/bin/atom restart
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
