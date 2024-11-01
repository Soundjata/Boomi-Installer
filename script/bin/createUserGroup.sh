#!/bin/bash

#service_group="boomigroup" # Optional: Create a dedicated group

# Check if the group already exists
if getent group "$service_group" >/dev/null 2>&1; then
  echo "Service group '$service_group' already exists."
else
  # Create the group
  groupadd "$service_group"
  echo "Service group '$service_group' created."
fi