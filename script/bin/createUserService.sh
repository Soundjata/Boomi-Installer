#!/bin/bash

sudo_content="
${service_user} ALL=NOPASSWD: /bin/systemctl start boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl stop boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl restart boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl status boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl show -p ActiveState boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl show -p SubState boomi-*.service
${service_user} ALL=NOPASSWD: /bin/systemctl show -p ExecMainPID boomi-*.service
"

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
  echo_yellow "Ajout des permissions sudo pour le user Boomi..."
  echo "$sudo_content" | sudo tee -a /etc/sudoers.d/boomi > /dev/null
  echo_green "Permissions sudo ajoutées avec succès."
fi
