#!/bin/bash

sudo_content="${service_user} ALL=NOPASSWD: /bin/systemctl start boomi-${atomName}.service
${service_user} ALL=NOPASSWD: /bin/systemctl stop boomi-${atomName}.service
${service_user} ALL=NOPASSWD: /bin/systemctl restart boomi-${atomName}.service
${service_user} ALL=NOPASSWD: /bin/systemctl status boomi-${atomName}.service
${service_user} ALL=NOPASSWD: /bin/systemctl show -p ActiveState boomi-${atomName}.service
${service_user} ALL=NOPASSWD: /bin/systemctl show -p SubState boomi-${atomName}.service
${service_user} ALL=NOPASSWD: /bin/systemctl show -p ExecMainPID boomi-${atomName}.service"

# Check if the user already exists
if id -u "$service_user" >/dev/null 2>&1; then
  echo "Service user '$service_user' already exists."
else
  # Create the user and assign to the group
  useradd -r -m -s /bin/false \
               -g "$service_group" \
               -c "Boomi service user" \
               "$service_user"
  echo "Service user '$service_user' created."
fi

# Toujours (re)créer le fichier sudoers pour éviter les doublons
echo_yellow "Ajout des permissions sudo pour le user Boomi..."
echo "$sudo_content" | sudo tee /etc/sudoers.d/boomi > /dev/null
sudo chmod 0440 /etc/sudoers.d/boomi
echo_green "Permissions sudo ajoutées avec succès."
