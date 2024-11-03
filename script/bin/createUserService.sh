#!/bin/bash

#service_user="boomiuser"  # Choose a descriptive name

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